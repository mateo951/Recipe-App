class RecipeFood < ApplicationRecord
  belongs_to :food
  belongs_to :recipe

  validates :quantity, presence: { message: "Quantity can't be null" }
  validates :quantity, numericality: { only_float: true, greater_than: 0, message: 'Quantity must be greater than 0' }
end
