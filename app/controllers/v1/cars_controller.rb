module V1
  class CarsController < ApplicationController
    before_action :set_car, except: [:create, :index, :all_cars, :search_by_body_type]
    before_action :set_available_cars, only: [:index, :search_by_body_type]

    def index(query_params = params[:query_params])
      @cars = @fetch_available_cars unless query_params
      @cars = @fetch_available_cars.where('manufacturer LIKE :query_params OR model LIKE :query_params',
                                            query_params: "%#{query_params}%")
      search_response(@cars)
    end

    def search_by_body_type(query_params = params[:query_params])
      @cars = @fetch_available_cars.where('body_type = ?', "#{query_params}")
      search_response(@cars)
      rescue ActiveRecord::StatementInvalid
        json_response({ error: "Invalid body type passed" }, :bad_request) 
    end

    def all_cars
      return json_response({ error: Message.unauthorized }, 403) unless is_admin?
      @cars = Car.where(deleted_at: nil).order('created_at DESC')
      render json: @cars
    end

    def create
      @car = current_user.cars.create!(car_params)
      json_response({ message: Message.create_success('Car AD'), data: @car }, :created)
    end

    def show
      return json_response({ car: @car }) unless is_mine?(@car) || is_admin?
      render json: @car
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

    def set_available_cars
      @fetch_available_cars = Car.where(deleted_at: nil, status: "Available").order('created_at DESC')
    end

    def search_response(model)
      return json_response({ cars: model }) unless is_admin?
      render json: model
    end
  end
end
