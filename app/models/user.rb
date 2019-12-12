class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password

  validates_presence_of :first_name, :last_name
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                  format: { with: VALID_EMAIL_REGEX }, length: { maximum: 75 }
  validates :password_digest, presence: true
  
  has_many :cars, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :flags, dependent: :destroy
end
