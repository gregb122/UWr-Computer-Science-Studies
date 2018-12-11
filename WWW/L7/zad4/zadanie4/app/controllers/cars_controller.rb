class CarsController < ApplicationController
  def index
    @cars = Car.all
  end

  def new
    @car = Car.new
  end

  def create 
    @car = Car.new(post_params)
    if @car.save
      flash[:success] = "Dokonano rejestracji!"
    else
      flash[:error] = "Wystąpiły następujące błędy: " + @car.errors.full_messages.to_s
    end
    redirect_to cars_path
  end

  private
  def post_params
    params.permit(:reg_number, :date_of_first_registration, :car_brand, :fuel_category, :production_year)
  end
end
