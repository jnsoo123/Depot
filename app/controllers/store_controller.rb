class StoreController < ApplicationController
  skip_before_action :authenticate_user!
  include CurrentCart
  before_action :set_cart
  
  def index
    
    if params[:search] || params[:category]
      if params[:search] == '' and params[:category] == ''
        redirect_to store_path
      elsif params[:category] == ''
        @products = Product.where("title like ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 5)
        @search_field = params[:search]
      elsif params[:search] == ''
        @products = Product.where(category_id: params[:category]).paginate(page: params[:page], per_page: 5)
        @select_field = params[:category]
      else
        @products = Product.where("title like ? and category_id = ?", "%#{params[:search]}%", params[:category]).paginate(page: params[:page], per_page: 5)
        @search_field = params[:search]
        @select_field = params[:category]
      end
    else
      @products = Product.paginate(page: params[:page], per_page: 5)
    end
    
    
  end
  
  
end
