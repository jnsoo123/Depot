class StoreController < ApplicationController
  skip_before_action :authenticate_user!
  include CurrentCart
  before_action :set_cart
  
  def index
#    if params[:category]
##      redirect_to store_path if params[:category] == ''
#      unless params[:search] == ''
#        @products = Product.where("title like ? and category_id = ?", "%#{params[:search]}%", params[:category])
#      end
#      @products = Product.where(category_id: params[:category]).paginate(:page => params[:page], :per_page => 5)
#    else
#      @products = Product.paginate(:page => params[:page], :per_page => 5)
#    end
    
    if params[:search] || params[:category]
      if params[:search] == '' and params[:category] == ''
        redirect_to store_path
      elsif params[:category] == ''
        @products = Product.where("title like ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 5)
      elsif params[:search] == ''
        @products = Product.where(category_id: params[:category]).paginate(page: params[:page], per_page: 5)
      else
        @products = Product.where("title like ? and category_id = ?", "%#{params[:search]}%", params[:category]).paginate(page: params[:page], per_page: 5)
      end
    else
      @products = Product.paginate(page: params[:page], per_page: 5)
    end
    
    
  end
  
  
end
