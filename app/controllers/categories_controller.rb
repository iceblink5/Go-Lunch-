class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
  end

  def create
    puts params
    @category = Category.create(params[:category])
    redirect_to(category_path(@category.id))
  end
end
