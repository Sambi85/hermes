FactoryBot.define do
  factory :user do
    # Using sequences to ensure unique email and phone_number
    sequence(:name) { |n| "Robot Person:#{n}" }
    sequence(:email) { |n| "john#{n}@example.com" }
    sequence(:phone_number) { |n| "01234567890#{n}" }

    password { "password" }
    password_confirmation { "password" }
  end
end

  