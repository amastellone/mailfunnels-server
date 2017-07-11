require 'rails_helper'

RSpec.describe "BroadcastLists", type: :request do
  describe "GET /broadcast_lists" do
    it "works! (now write some real specs)" do
      get broadcast_lists_path
      expect(response).to have_http_status(200)
    end
  end
end
