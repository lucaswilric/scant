class DropboxController < ApplicationController
  include DropboxHelper

  def auth
    redirect_to dropbox_flow(session).start
  end

  def auth_finish
    flow = dropbox_flow(session)
    access_token, user_id = flow.finish(params)

    user = current_user
    user.dropbox_access_token = access_token
    user.dropbox_user_id = user_id
    if user.save
      flash[:notice] = "You have successfully linked Scant to Dropbox."
    else
      flash[:error] = "Could not link your Scant account to Dropbox."
    end

    redirect_to user
  end

  def unauthorise
    user = current_user

    user.dropbox_access_token = nil
    user.dropbox_user_id = nil

    if user.save
      flash[:notice] = "You have unlinked Scant from Dropbox."
    else
      flash[:error] = "Could not unlink your Scant account from Dropbox."
    end  

    redirect_to user
  end
end
