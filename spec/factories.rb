FactoryBot.define do
  factory :user do
    username { 'John' }
    password { 'password' }
    sequence(:email) { |n| "#{username}#{n}@apartmentalerts.com" }
  end

  factory :alert do
    name { 'Foobar' }
    city { 'des moines' }
    search_params { { hasPic: '1', max_bedrooms: '1' } }
    user

    trait :emails_enabled do
      emails_enabled { true }
    end
  end

  factory :craigslist_post do
    post { "Some HTML"}
    alert
  end
end
