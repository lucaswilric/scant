require 'spec_helper'

class FakeRequestToken
  def authorize_url
    "http://example.com/"
  end
end

class FakeEvernoteClient
  def request_token(opts)
    FakeRequestToken.new
  end
end

class Factory
  def evernote_client(auth_token)
    FakeEvernoteClient.new
  end
end

describe EvernoteController do

  let(:bob) { User.find_or_create_by_email(name: 'Bob', email: 'bob@example.com', password: 'abcd1234') }

  before :each do
    sign_in :user, bob
  end

  describe "GET 'auth'" do
    it "returns http redirect" do
      get 'auth'
      response.status.should be(302)
    end
  end

  describe "GET 'callback'" do
    it "returns http redirect" do
      get 'callback'
      response.status.should be(302)
    end
  end

end
