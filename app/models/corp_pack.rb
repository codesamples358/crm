class CorpPack < ApplicationRecord
  attr_accessor :date_from, :date_to

  belongs_to :manager, class_name: 'User'
  belongs_to :call, optional: true

  has_many :corp_pack_services
  has_many :services, through: :corp_pack_services

  belongs_to :player

  accepts_nested_attributes_for :corp_pack_services

  validates :manager, presence: true

  validates :date, presence: true, format: /\A\d{2}\.\d{2}\.\d{4}\Z/
  validates :time, presence: true

  validates :prepayment_sum, numericality: true, allow_blank: true

  validate :validate_datetime

  before_save :assign_datetime

  ATTR_VALUES = {
    mode: [
      'Выездной квест',
      'Аренда зала № 1',
      'Аренда зала № 2',
      'Аренда зала № 3',
      'Аренда зала № 4',
      'Аренда зала № 5',
      'Аренда зала № 6',
      'День рождения (ИЦ закрыт)',
      'Детский день рождения',
      'Взрослый день рождения',
      'Корпоратив',
      'Кафе взрослый',
      'Кафе детский',
      'Корпоратив закрытие'
    ],

    status: [
      'Входящий запрос',
      'Забронировано',
      'Бронь подтверждена',
      'Внесена предоплата',
      'Бронь отменена',
      'Завершен',
      'Отложено'
    ],

    payment_type: [
      'Наличные',
      'Карта',
      'Смешанный',
      'Рассчетный счет'
    ],

    game_center: [
      'Сургут'
    ],

    prepayment_type: :payment_type,
    info_source: [ 'Сайт', 'Звонок', 'Визит', 'Другое' ]
  }


  def profit
    0
  end

  def self.new_parse_dates(params)
    new.assign_params(params)
  end

  def assign_params(params)
    date = params.delete(:date)
    time = params.delete(:time)

    self.attributes = params

    if date && date !~ /\A\d{2}\.\d{2}\.\d{4}\Z/
      @date_invalid = true
    else
      self.date = Date.strptime(date, Date::DATE_FORMATS[:default])
    end

    if time && time !~ /\d{2}:\d{2}/
      @time_invalid = true
    else
      self.time = time
    end

    self
  end

  def validate_datetime
    errors.add(:date, :invalid) if @date_invalid
    errors.add(:time, :invalid) if @time_invalid
  end

  def time
    if t = self[:time]
      "#{t.hour}:#{t.min.to_s.rjust(2, '0')}"
    end
  end

  def date_and_time
    "#{date} #{time}"
  end

  def assign_datetime
    self.datetime = self.date.to_time + self[:time].hour.hours + self[:time].min.minutes    
  end
end
