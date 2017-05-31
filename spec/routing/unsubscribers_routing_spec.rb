require "rails_helper"

RSpec.describe UnsubscribersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/unsubscribers").to route_to("unsubscribers#index")
    end


    it "routes to #show" do
      expect(:get => "/unsubscribers/1").to route_to("unsubscribers#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/unsubscribers").to route_to("unsubscribers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/unsubscribers/1").to route_to("unsubscribers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/unsubscribers/1").to route_to("unsubscribers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/unsubscribers/1").to route_to("unsubscribers#destroy", :id => "1")
    end

  end
end
