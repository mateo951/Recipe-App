class User < ApplicationRecord
  has_many :recipes
  has_many :foods
  has_many :inventories

  validates :name, presence: { message: "Name can't be null" }
end
