class FlagsController < ApplicationController
  before_action :set_car
  before_action :set_flag, except: [:index, :create]
  before_action :check_flag, only: [:show, :destroy]

  def index
    return json_response({ error: Message.unauthorized }, 403) unless is_admin?
    @flags = @car.flags.order('created_at DESC')
    render json: @flags
  end

  def create
    return json_response({ error: Message.unauthorized }, 403) if is_mine?(@car)
    @flag = @car.flags.create!({
      user_id: current_user.id,
      reason: params[:reason],
      description: params[:description]
    })
    json_response({ message: Message.create_success('Flag'), flag: @flag }, :created)
  end

  def show
    render json: @flag
  end

  def update
    return json_response({ error: Message.unauthorized}, 403) unless is_mine?(@flag)
    @flag.update!(reason: params[:reason], description: params[:description])
    json_response({ message: Message.update_success('Flag'), flag: @flag })
  end

  def destroy
    @flag.destroy
    json_response({ message: Message.delete_success('Flag'), flag: @flag })
  end

  private

  def set_car
    @car = Car.where(deleted_at: nil).find(params[:car_id])
  end

  def set_flag
    @flag = @car.flags.find(params[:id])
  end
  
  def check_flag
    return json_response({ error: Message.unauthorized}, 403) unless is_mine?(@flag) || is_admin?  
  end
end
