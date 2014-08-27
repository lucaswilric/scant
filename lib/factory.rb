class Factory
  def pvc(*args)
    PVC.new(*args)
  end

  def converter(*args)
    Converter.new(self, *args)
  end

  def scanner
    Scanner.new(Settings.scanner_name)
  end

  def evernote_client(auth_token)
    EvernoteOAuth::Client.new(token: auth_token, consumer_key: Settings.evernote_oauth_key, consumer_secret: Settings.evernote_oauth_secret, sandbox: Settings.evernote_sandbox)
  end
end
