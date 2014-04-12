require 'dropbox_sdk'

module DropboxHelper
  def dropbox_flow(session)
    DropboxOAuth2Flow.new(Settings.dropbox_key, Settings.dropbox_secret, dropbox_auth_finish_url, session, :csrf_token_session_key)
  end

  def save_to_dropbox(filename, user)
    raise "Not authorised." unless user.dropbox?

    client = DropboxClient.new(user.dropbox_access_token)

    # Instead of `content`, we might put `open('myfile.pdf')`
    response = client.put_file("/#{filename.sub(Settings.doc_root, '')}", open(filename))

    #response['path'] == filename
  end
end
