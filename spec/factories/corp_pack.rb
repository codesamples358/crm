FactoryBot.define do
  factory :corp_pack do
    date                  { Time.now.to_date.to_s }
    time                  { "12:00" }
    player
    manager

    factory :new_corp_pack do
      player_id  { create(:player).id  }
      manager_id { create(:manager).id }
      # association :manager, strategy: :create
    end
  end
end
