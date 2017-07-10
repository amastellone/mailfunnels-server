require "rails_helper"

RSpec.describe BroadcastListsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/broadcast_lists").to route_to("broadcast_lists#index")
    end


    it "routes to #show" do
      expect(:get => "/broadcast_lists/1").to route_to("broadcast_lists#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/broadcast_lists").to route_to("broadcast_lists#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/broadcast_lists/1").to route_to("broadcast_lists#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/broadcast_lists/1").to route_to("broadcast_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/broadcast_lists/1").to route_to("broadcast_lists#destroy", :id => "1")
    end

  end
end
