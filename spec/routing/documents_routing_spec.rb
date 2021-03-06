require "spec_helper"

describe DocumentsController do
  describe "routing" do

    it "routes to #index" do
      get("/documents").should route_to("documents#index")
    end

    it "routes to #show" do
      get("/documents/1").should route_to("documents#show", :id => "1")
    end

    it "routes to #create" do
      post("/documents").should route_to("documents#create")
    end

    it "routes to #destroy" do
      delete("/documents/1").should route_to("documents#destroy", :id => "1")
    end

  end
end
