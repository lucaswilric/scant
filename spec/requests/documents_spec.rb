require 'spec_helper'
require 'requests_helper'

describe "Documents" do
  let(:bob) { User.find_or_create_by_email(email: 'bob@example.com', name: 'Bob', password: 'abcd1234') }
  
  describe "GET /documents" do
    it "renders a page for documents when signed in" do
      login bob
      get documents_path
      response.status.should be(200)
    end

    it "redirects to home when not signed in" do
      get documents_path
      response.status.should be(302)
    end
  end
end
