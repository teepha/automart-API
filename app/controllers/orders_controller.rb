class OrdersController < ApplicationController
  before_action :set_car
  before_action :set_car_order, except: [:index, :create]
  before_action :check_car_order, only: [:update_status]

  def index
    return json_response({ error: Message.unauthorized }, 403) unless is_mine?(@car) || is_admin?
    @orders = @car.orders.where(deleted_at: nil).order('amount DESC')
    return render json: @orders, adapter: :json
  end

  def create
    return json_response({ error: Message.car_unavailable}, 403) if check_status?(@car, "sold")
    return json_response({ error: Message.unauthorized }, 403) if is_mine?(@car)
    @order = current_user.orders.create!({
      car_id: params[:car_id],
      amount: params[:amount],
    })
    json_response({ message: Message.create_success('Order'), data: @order }, :created)
  end

  def show
    return json_response({ error: Message.unauthorized }, 403) unless is_mine?(@car) || is_mine?(@order) || is_admin?
    render json: @order, adapter: :json
  end

  def update
    return json_response({ error: Message.order_unavailable }, 422) if check_status?(@order, "accepted")
    return json_response({ error: Message.unauthorized }, 403) unless is_mine?(@order)
    @order.update!(amount: params[:amount])
    json_response({ message: Message.update_success('Order'), data: @order })
  end

  def update_status
    @order.update!(status: params[:status])
    json_response({ message: Message.update_success('Order status'), data: @order })
  end

  def destroy
    delete_record(@order, "accepted", Message.order_unavailable, 'Order')
    @order.destroy if check_status?(@order, "pending") && (is_mine?(@order) || is_admin?)
  end

  private

  def set_car
    @car = Car.where(deleted_at: nil).find(params[:car_id])
  end

  def set_car_order
    @order = @car.orders.where(deleted_at: nil).find(params[:id])
  end

  def check_car_order
    return json_response({ error: Message.order_unavailable }, 422) if check_status?(@order, "accepted")
    return json_response({ error: Message.car_unavailable }, 403) if @car.orders.where(status: "accepted").any?
    return json_response({ error: Message.unauthorized }, 403) unless is_mine?(@car)
  end
end
