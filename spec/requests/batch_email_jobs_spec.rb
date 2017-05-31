require 'rails_helper'

RSpec.describe "BatchEmailJobs", type: :request do
  describe "GET /batch_email_jobs" do
    it "works! (now write some real specs)" do
      get batch_email_jobs_path
      expect(response).to have_http_status(200)
    end
  end
end
