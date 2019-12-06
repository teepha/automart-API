class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :car_id, :amount, :status
end
