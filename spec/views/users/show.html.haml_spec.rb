require 'spec_helper'

describe "users/show.html.haml" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      name: "Bob Example",
      email: "bob@example.com"
    ))
  end

  it "renders the user's name" do
    render

    rendered.should match /Bob Example/
  end

  it "renders the user's email" do
    render

    rendered.should match /bob@example.com/
  end

  it "says the user is linked to Dropbox" do
    @user.dropbox_user_id = 'dummy'

    render

    rendered.should match /<span class='linked_to_dropbox'>Yes<\/span>/
  end

  it "says the user is not linked to Dropbox" do
    @user.dropbox_user_id = nil

    render

    rendered.should match /<span class='linked_to_dropbox'>No<\/span>/
  end
end
