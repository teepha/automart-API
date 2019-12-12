class Flag < ApplicationRecord
  validates_presence_of :reason, :description

  belongs_to :car
  belongs_to :user
end
