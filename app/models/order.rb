class Order < ApplicationRecord
  validates_presence_of :status
  validates :amount, numericality: true

  belongs_to :user
  belongs_to :car
end
