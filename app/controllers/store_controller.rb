class StoreController < ApplicationController
  skip_before_action :authenticate_user!
  include CurrentCart
  before_action :set_cart
  
  def index
    if params[:category]
      @products = Product.where(category_id: params[:category]).paginate(:page => params[:page], :per_page => 5)
    else
      @products = Product.paginate(:page => params[:page], :per_page => 5)
    end
  end
  
  
end
