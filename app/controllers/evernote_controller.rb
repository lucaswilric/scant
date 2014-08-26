class EvernoteController < ApplicationController
  include EvernoteHelper

  def authorize
    callback_url = request.url.chomp("authorize").concat("callback")
    session[:request_token] = client.request_token(:oauth_callback => callback_url)

    if session[:request_token]
      redirect_to session[:request_token].authorize_url
    else
      # You shouldn't be invoking this if you don't have a request token
      @last_error = "Request token not set."
      erb :error
    end
  end

  def callback
    unless params['oauth_verifier'] || session[:request_token]
      @last_error = "Content owner did not authorize the temporary credentials"
      halt erb :error
    end

    oauth_verifier = params['oauth_verifier']

    begin
      current_user.evernote_access_token = session[:request_token].get_access_token(:oauth_verifier => oauth_verifier)
      redirect_to user_url(current_user)
    rescue => e
      @last_error = 'Error extracting access token'
      erb :error
    end
  end
end
