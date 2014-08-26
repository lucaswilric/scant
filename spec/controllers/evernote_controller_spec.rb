require 'spec_helper'

describe EvernoteController do

  describe "GET 'request_token'" do
    it "returns http success" do
      get 'request_token'
      response.should be_success
    end
  end

  describe "GET 'authorize'" do
    it "returns http success" do
      get 'authorize'
      response.should be_success
    end
  end

  describe "GET 'callback'" do
    it "returns http success" do
      get 'callback'
      response.should be_success
    end
  end

end
