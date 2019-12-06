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
  validates :price, numericality: true
  validates_presence_of :model, :manufacturer, :body_type
  
  belongs_to :user
  has_many :orders
end
