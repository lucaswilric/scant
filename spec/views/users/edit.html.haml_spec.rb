require 'spec_helper'

describe "users/edit.html.haml" do
  before(:each) do
    @user = assign(:user, stub_model(User))
  end


  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_path(@user), "post" do
      
    end
  end

  it "says the user is linked to Dropbox" do
    @user.dropbox_user_id = 'dummy'

    render

    rendered.should match /Linked to Dropbox/
  end

  it "says the user is not linked to Dropbox" do
    @user.dropbox_user_id = nil

    render

    rendered.should match /Not linked to Dropbox/
  end
end
