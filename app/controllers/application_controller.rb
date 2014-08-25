class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    if current_user
      @sidebar_document = Document.new

      last_document = current_user.documents.last
      
      @last_format = (last_document.try(:file_name) || 'jpg').split('.').last
      @formats = Scanner.supported_formats

      @last_quality = (last_document.try(:quality) || 'rough').to_s
      @qualities = Scanner.supported_qualities.map(&:to_s)
    end
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
