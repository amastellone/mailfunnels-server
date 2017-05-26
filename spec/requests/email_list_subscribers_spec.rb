require 'rails_helper'

RSpec.describe "EmailListSubscribers", type: :request do
  describe "GET /email_list_subscribers" do
    it "works! (now write some real specs)" do
      get email_list_subscribers_path
      expect(response).to have_http_status(200)
    end
  end
end
