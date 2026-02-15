class Item < ApplicationRecord
  belongs_to :todo

  # Validations
  validates :name, presence: true
end
