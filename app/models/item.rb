class Item < ApplicationRecord
  belongs_to :entry

  validates_presence_of :name
end
