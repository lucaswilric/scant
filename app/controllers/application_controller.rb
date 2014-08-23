class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    @sidebar_document = Document.new

    last_document = Document.where(user_id: current_user.id).order('id desc').limit(1).first
    @last_format = last_document.file_name.split('.').last

    @formats = Scanner.supported_formats
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
