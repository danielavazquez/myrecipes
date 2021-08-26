class IngredientsController < ApplicationController

  def new
  end
  
  def create
  end

  def edit
  end

  def updated
  end

  def show
  end

  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 5)
  end


end