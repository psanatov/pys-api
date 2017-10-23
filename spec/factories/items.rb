# spec/factories/items.rb
FactoryGirl.define do
  factory :item do
    name { Faker::StarWars.character }
    visible false
    entry_id nil
  end
end
