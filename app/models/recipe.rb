class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_foods, dependent: :destroy

  validates :name, presence: { message: "Name can't be null" }
  validates :description, presence: { message: "Description can't be null" }
  after_create_commit { broadcast_prepend_to 'recipes', partial: "shared/recipe" }
end
