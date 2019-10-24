Snippet.add(:koans) do
  on

  def koans
    load "#{Rails.root}/dev/koans/path_to_enlightenment.rb"
    Neo::ThePath.new.walk

  end
end
