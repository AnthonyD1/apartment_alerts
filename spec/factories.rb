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
    sequence(:title) { |n| "#{n} Bedrooms" }
    link { 'https:://www.example.com' }
    post { 'Some HTML'}
    price { 800 }
    date { DateTime.current }
    alert

    trait :favorite do
      favorite { true }
    end

    trait :soft_deleted do
      deleted_at { DateTime.current }
    end
  end
end
