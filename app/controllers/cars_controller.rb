class CarsController < ApplicationController
  before_action :set_car, except: [:create, :index]

  def index
    @cars = Car.where(deleted_at:  nil).order('created_at DESC')
    return json_response({ cars: @cars }) unless is_admin?
    render json: @cars, adapter: :json
  end

  def create
    @car = current_user.cars.create!(car_params)
    json_response({ message: Message.create_success('Car AD'), data: @car }, :created)
  end

  def show
    return json_response({ car: @car }) unless is_mine?(@car) || is_admin?
    render json: @car, adapter: :json
  end

  def update
    return json_response({ error: Message.unauthorized }, 403) unless is_mine?(@car)
    return json_response({ error: Message.car_unavailable }, 422) unless check_status?(@car, "Available")
    
    @car.update!(car_params)
    json_response({ message: Message.update_success('Car AD'), data: @car })
  end

  def destroy
    delete_record(@car, "sold", Message.car_unavailable, 'Car AD')
    @car.destroy if check_status?(@car, "Available") && (is_mine?(@car) || is_admin?)
  end

  private

  def car_params
    params.permit(:state, :status, :price, :manufacturer, :model, :body_type)
  end

  def set_car
    @car = Car.where(deleted_at:  nil).find(params[:id])
  end
end
