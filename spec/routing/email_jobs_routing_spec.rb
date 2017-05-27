require "rails_helper"

RSpec.describe EmailJobsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/email_jobs").to route_to("email_jobs#index")
    end


    it "routes to #show" do
      expect(:get => "/email_jobs/1").to route_to("email_jobs#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/email_jobs").to route_to("email_jobs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/email_jobs/1").to route_to("email_jobs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/email_jobs/1").to route_to("email_jobs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/email_jobs/1").to route_to("email_jobs#destroy", :id => "1")
    end

  end
end
