class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  protected
    def authorize
      # unless User.find_by(id: session[:user_id])
      #   redirect_to login_url, notice: 'Please Login'
      # end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << [:name, :email, :username]
      devise_parameter_sanitizer.for(:account_update) << [:name, :email, :username]
    end
end
