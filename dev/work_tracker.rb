module WorkTracker
  mattr_accessor :curr_state
  self.curr_state = :not_working
  STATES = [:working, :not_working, :research]
  BASE_DIR = "#{Rails.root}/dev/wtracker"

  extend self

  class StatChange
    attr_accessor :time, :state

    def to_yaml
      []
    end
  end

  def ww
    write_stat_change!
  end

  def other_state(state)
    STATES[
      (STATES.index(state) + 1) % 2
    ]
  end

  def today_file_name
    "#{BASE_DIR}/#{3.hours.ago.strftime("%Y_%m_%d")}.yml"
  end

  def write_stat_change!
    create_file_unless_exists!

    works = YAML.load_file(today_file_name)
    new_state = other_state(!today_works.empty? && today_works[-1][0] || :not_working)
    works << [new_state, Time.now.to_s(:db)]

    File.open(today_file_name, "w") {|f| f.write(works.to_yaml)}

    total = total_work(today_file_name)
    hours, mins = total.to_i, ((total - total.to_i) * 60).to_i

    puts "*** #{new_state.to_s.gsub("_", " ").upcase} *** \n TOTAL TODAY: #{hours}h #{mins}m"
  end

  def today_works
    create_file_unless_exists!
    YAML.load_file(today_file_name)
  end

  def create_file_unless_exists!
    if !Dir.exists?(BASE_DIR)
      `mkdir #{BASE_DIR}`
    end

    if !File.exists?(today_file_name)
      File.open(today_file_name, "w") {|file| file.write([].to_yaml)}
    end
  end

  def total_work(file_name)
    works = YAML.load_file(file_name)
    total = 0.0

    works.each_with_index {|state, i|
      next if i == 0
      prev_state = works[i - 1]

      if works[i - 1][0] == :working && works[i][0] == :not_working
        total += (time_from(works[i][1]) - time_from(works[i - 1][1])) / 3600.0
      end
    }

    (total * 100).to_i.to_f / 100
  end

  def time_from(val)
    if val.is_a?(String)
      Time.parse(val)
    elsif val.is_a?(Time)
      val
    end
  end

  def report_work!
    Dir["#{BASE_DIR}/*.yml"].each do |file_name|
      File.open(file_name.gsub(".yml", ".total"), "w") {|file|
        file.write(total_work(file_name).to_f)
      }
    end
  end

  def work_times
    Dir["#{BASE_DIR}/*.yml"].map do |file_name|
      md = file_name.match(/(\d{4})_(\d{2})_(\d{2})/)
      date = Date.new(md[1].to_i, md[2].to_i, md[3].to_i)
      holidays = HOLIDAYS[[date.year, date.month]] || []

      if !holidays.include?(date.day)
        [date, total_work(file_name).to_f]
      end
    end.compact
  end

  HOLIDAYS = {
    [2013, 5] => [1, 2, 3, 9, 10],
    [2013, 6] => [12],
    [2013, 10] => [28, 29, 30, 31],
    [2013, 11] => [1, 4, 5],
    [2013, 12] => [2, 3, 4, 5, 6, 9, 10, 11],
    [2014, 1] => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
    [2014, 3] => (11 .. 14).to_a + (17 .. 21).to_a,
    [2014, 5] => (1 .. 4).to_a + (9 .. 11).to_a,
    [2014, 6] => [12, 13]
  }

  def work_hours(date)
    holidays = HOLIDAYS[[date.year, date.month]] || []
    count = 0
    (date.at_beginning_of_month .. date.at_end_of_month).each do |d|
      count += 1 unless d.wday == 6 || d.wday == 0 || holidays.include?(d.day)
    end

    count * 8
  end

  def write_report
    times = work_times.sort_by {|t| t[0]}
    total = times.map{|t| t[1]}.sum

    months_totals = Hash[times.group_by {|t| [t[0].year, t[0].month]}.map{|month, times| [month, times.map{|t| t[1]}.sum]}]
    puts months_totals.inspect

    File.open("#{BASE_DIR}/work_report.txt", "w") do |file|
      prev = nil
      times.each_with_index do |(date, time), i|
        file.printf("%s %5.2f\n", "#{date.to_time.strftime('%d %b')}", time)


        if i < times.size - 1 && times[i + 1][0].month != date.month || i == times.size - 1
          file.puts('-' * 12)

          if date < Date.new(2013, 4, 30)
            file.printf("Month total: %5.2f\n\n", months_totals[[date.year, date.month]])
          else
            file.printf("Month total: %5.2f; Sum: %5.0f\n\n", months_totals[[date.year, date.month]], months_totals[[date.year, date.month]] * 10 * 66)
          end
        end

        prev = date
      end

      file.puts('-' * 12)
      file.printf("Total: %5.2f\n", total)
    end
  end

  def grand_total
    total = 0

    Dir["#{BASE_DIR}/*.yml"].each do |file_name|
      total += total_work(file_name).to_f
    end

    total
  end
end

Kernel.send(:include, WorkTracker)
