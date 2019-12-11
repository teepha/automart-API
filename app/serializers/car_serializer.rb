class CarSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :state, :status, :price, :manufacturer, :model, :body_type, :orders

  def orders
    object.orders.where(deleted_at: nil).order('amount DESC')
                    .select("id, user_id, car_id, amount, status")
  end
end
