class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    @sidebar_document = Document.new
  end

  def check_user
    redirect_to home_index_url if current_user.nil?
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def forbidden
    raise ActionController::RoutingError.new('Forbidden')
  end

  def factory
    @factory ||= Factory.new
  end
end
