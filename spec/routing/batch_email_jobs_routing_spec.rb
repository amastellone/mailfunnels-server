require "rails_helper"

RSpec.describe BatchEmailJobsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/batch_email_jobs").to route_to("batch_email_jobs#index")
    end


    it "routes to #show" do
      expect(:get => "/batch_email_jobs/1").to route_to("batch_email_jobs#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/batch_email_jobs").to route_to("batch_email_jobs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/batch_email_jobs/1").to route_to("batch_email_jobs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/batch_email_jobs/1").to route_to("batch_email_jobs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/batch_email_jobs/1").to route_to("batch_email_jobs#destroy", :id => "1")
    end

  end
end
