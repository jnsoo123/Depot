class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @categories = Category.paginate(page: params[:page], per_page: 10)
    respond_with(@categories)
  end

  def show
    redirect_to categories_path
  end

  def new
    @category = Category.new
    respond_with(@category)
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    
#    respond_with(@category)
#    redirect_to categories_path, notice: "Category Created!"
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category Created!' }
      end
    end
  end

  def update
    @category.update(category_params)
    respond_with(@category)
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_path, notice: 'Category Deleted!' }
    end
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
