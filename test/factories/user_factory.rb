require 'ffaker'

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "#{n}-#{FFaker::Internet.email}" }
    password { SecureRandom.hex(10) }
    password_confirmation { password }
    confirmed_at { Time.zone.now }

    full_name { FFaker::Name.name }

    factory :unconfirmed_user do
      confirmed_at nil
    end
  end
end
