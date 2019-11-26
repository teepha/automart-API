class Car < ApplicationRecord
  validates :state, inclusion: { in: %w(new used) }
  validates :status, inclusion: { in: %w(sold available) }
  validates_presence_of :price, :model, :manufacturer
  
  belongs_to :user
  belongs_to :body_type
  has_many :orders
end
