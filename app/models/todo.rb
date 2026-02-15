class Todo < ApplicationRecord
  has_many :items, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :created_by, presence: true
end
