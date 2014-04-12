require 'spec_helper'

describe UsersController do

  let(:bob) { User.find_or_create_by_email(name: 'Bob', email: 'bob@example.com', password: 'abcd1234') }

  before :each do
    sign_in :user, bob
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', id: bob.id
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', id: bob.id
      response.should be_success
    end
  end

end
