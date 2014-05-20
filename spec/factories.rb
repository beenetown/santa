require 'faker'

FactoryGirl.define do
  factory :auth do
    name "John"
    email "john@example.com"
    provider 'santa'
    password "password"
    password_confirmation "password"
  end

  factory :user do
  end

  factory :gift do
  end

  factory :group do
    select_date Time.new(2014, 11, 30).to_date
    open_date Time.new(2014, 12, 25).to_date
    name "Test Group"
  end

  factory :invite do
  end
end