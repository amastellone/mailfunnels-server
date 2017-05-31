require 'rails_helper'

RSpec.describe "Unsubscribers", type: :request do
  describe "GET /unsubscribers" do
    it "works! (now write some real specs)" do
      get unsubscribers_path
      expect(response).to have_http_status(200)
    end
  end
end
