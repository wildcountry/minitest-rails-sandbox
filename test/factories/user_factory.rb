require 'ffaker'

FactoryGirl.define do
  factory :base_user, class: User do
    sequence(:email) { |n| "#{n}-#{FFaker::Internet.email}" }
    password { SecureRandom.hex(10) }
    password_confirmation { password }

    full_name { FFaker::Name.name }

    trait :confirmed do
      confirmed_at { Time.zone.now }
    end

    factory :user, traits: [:confirmed]
    factory :confirmed_user, traits: [:confirmed]
    factory :unconfirmed_user
  end
end
