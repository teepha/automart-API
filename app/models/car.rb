class Car < ApplicationRecord
  validates :state, inclusion: { in: %w(new used) }
  validates :status, inclusion: { in: %w(sold available) }
  validates_presence_of :price, :model, :manufacturer, :user_id, :body_type_id
  # validates :user_id, presence: true
  # validates :body_type_id, presence: true

  belongs_to :user
  belongs_to :body_type
  has_many :orders
end
