require 'rails_helper'

RSpec.describe "Funnels", type: :request do
  describe "GET /funnels" do
    it "works! (now write some real specs)" do
      get funnels_path
      expect(response).to have_http_status(200)
    end
  end
end
