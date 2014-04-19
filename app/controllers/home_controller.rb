class HomeController < ApplicationController
  def index
    redirect_to documents_url if current_user
  end
end
