# spec/factories/entries.rb
FactoryGirl.define do
  factory :entry do
    title { Faker::Lorem.word }
    created_by { Faker::Number.number(10) }
  end
end
