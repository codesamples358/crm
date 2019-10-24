FactoryBot.define do
  factory :user, aliases: [:manager] do
    transient do
      sequence(:username) { |n| "joe#{n}" }
    end

    name                  { username }
    email                 { "#{username}@gmail.com" }
    password              { "blah1234" }
    password_confirmation { "blah1234" }
  end
end
