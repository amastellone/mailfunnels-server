require 'rails_helper'

RSpec.describe "EmailJobs", type: :request do
  describe "GET /email_jobs" do
    it "works! (now write some real specs)" do
      get email_jobs_path
      expect(response).to have_http_status(200)
    end
  end
end
