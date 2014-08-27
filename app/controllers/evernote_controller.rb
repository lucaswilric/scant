class EvernoteController < ApplicationController
  include EvernoteHelper

  def auth
    callback_url = request.url.chomp("auth").concat("callback")
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
      raise "Content owner did not authorise the temporary credentials"
    end

    oauth_verifier = params['oauth_verifier']

    begin
      current_user.evernote_access_token = session[:request_token].get_access_token(:oauth_verifier => oauth_verifier)
      
      if current_user.save
        flash[:notice] = "You have linked Scant to Evernote"
      else
        flash[:error] = "Could not link your Scant account to Evernote"
      end

      redirect_to user_url(current_user)
    rescue => e
      raise 'Error extracting access token'
    end
  end

  def unauthorise
    user = current_user

    user.evernote_access_token = nil

    if user.save
      flash[:notice] = "You have unlinked Scant from Evernote."
    else
      flash[:error] = "Could not unlink your Scant account from Evernote."
    end  

    redirect_to user
  end
end
