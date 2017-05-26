require "rails_helper"

RSpec.describe EmailListSubscribersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/email_list_subscribers").to route_to("email_list_subscribers#index")
    end


    it "routes to #show" do
      expect(:get => "/email_list_subscribers/1").to route_to("email_list_subscribers#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/email_list_subscribers").to route_to("email_list_subscribers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/email_list_subscribers/1").to route_to("email_list_subscribers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/email_list_subscribers/1").to route_to("email_list_subscribers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/email_list_subscribers/1").to route_to("email_list_subscribers#destroy", :id => "1")
    end

  end
end
