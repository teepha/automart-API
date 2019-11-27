class Car < ApplicationRecord
  enum body_type: {
    car: 'car',
    truck: 'truck',
    trailer: 'trailer',
    van: 'van',
    bus: 'bus',
    minibus: 'minibus'
  }

  validates :state, inclusion: { in: %w(new used) }
  validates :status, inclusion: { in: %w(sold available) }
  validates_presence_of :price, :model, :manufacturer
  
  belongs_to :user
  has_many :orders
end
