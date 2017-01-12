FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Alex Rodriguez #{n}" }
    sequence(:email) { |n| "alex#{n}@example.com" }
    password "password"
  end
end
