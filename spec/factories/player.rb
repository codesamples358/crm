FactoryBot.define do
  factory :player do
    transient do
      sequence(:username) { |n| "joe#{n}" }
    end

    name                  { username }
    email                 { "#{username}@gmail.com" }
    sequence(:phone)      { |n| "+7 (916) 300-#{n.to_s.rjust(4, '0')}"}
  end
end
