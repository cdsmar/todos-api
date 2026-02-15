require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let!(:users) { create_list(:user, 2) }
  let(:user_id) { users.first.id }

  describe "GET /users" do
    before { get "/users" }
    it "returns users" do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end
    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end
  end
end