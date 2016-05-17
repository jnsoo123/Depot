class StoreController < ApplicationController
  skip_before_action :authorize

  include CurrentCart
  before_action :set_cart
  def index
#     @products = Product.order(:title)
    @products = Product.paginate(:page => params[:page], :per_page => 5)
  end
end
