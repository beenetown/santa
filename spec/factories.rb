require 'faker'

FactoryGirl.define do
  factory :auth do
    name "John"
    email "john@example.com"
    provider "santa"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :user do
  end

  factory :gift do
  end

  factory :group do
    select_date Time.new(2014, 11, 30).to_date
    open_date Time.new(2014, 12, 25).to_date
  end

  factory :invite do
  end
end