Snippet.add(:users) do
  on

  def create_players(count = 100, name = "Joe", phone_base = 400)
    (1 ... count).each do |i|
      Player.create(name: "#{name}#{i}", phone: "+7 (916) #{phone_base + i}-8901", city: "Сургут", email: "#{name.downcase}#{i}@surgut.com", male: true)
    end
  end

  def create200
    create_players(100, "Joe")
    create_players(100, "Frank", 600)
  end
end
