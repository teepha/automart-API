class Order < ApplicationRecord
  validates_presence_of :amount, :status

  belongs_to :user
  belongs_to :car
end
