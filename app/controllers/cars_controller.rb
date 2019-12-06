class CarsController < ApplicationController
  before_action :set_car, except: [:create, :index]

  def index
    @cars = Car.where(deleted_at:  nil).order('created_at DESC')
    return json_response({ data: @cars })
  end

  def create
    @car = current_user.cars.create!(car_params)
    json_response({
      message: Message.create_success('Car AD'),
      data: @car
    }, :created)
  end

  def show
    json_response({ data: @car })
  end

  def update
    return json_response({ error: Message.unauthorized }, 403) unless is_mine?(@car)
    return json_response({ error: Message.update_failure }, 422) unless is_available?(@car)
    
    @car.update!(car_params)
    json_response({
      message: Message.update_success('Car AD'),
      data: @car
    })
  end

  def destroy
    return json_response({ error: Message.unauthorized }, 403) unless is_mine?(@car) || is_admin?
    return json_response({ error: Message.delete_failure }, 403) if is_sold?(@car) && !is_admin?
    @car.update!(deleted_at: Time.now) if is_sold?(@car) && is_admin?
    @car.destroy if is_available?(@car) && (is_mine?(@car) || is_admin?)
    json_response({ message: Message.delete_success('Car AD'), data: @car })
  end

  private

  def car_params
    params.permit(:state, :status, :price, :manufacturer, :model, :body_type)
  end

  def set_car
    @car = Car.find(params[:id])
  end

  def is_available?(car)
    car[:status] == "Available"
  end

  def is_sold?(car)
    car[:status] == "sold"
  end
end
