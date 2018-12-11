class PersonsController < ApplicationController
  def index
    @persons = Person.page(params[:page]).per(5)
  end
end
