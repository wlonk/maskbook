class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers 

  protect_from_forgery with: :exception
end
