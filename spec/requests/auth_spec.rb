require 'rails_helper'

RSpec.describe "Auth API", type: :request do
  let!(:user) { create(:user) }

  describe "POST /signup" do
    let(:valid_attributes) { { name: "Bob", email: "bob@example.com", password: "secret" } }
    it "creates a new user" do
      post "/signup", params: valid_attributes
      expect(response).to have_http_status(201)
    end
  end

  describe "POST /auth/login" do
    it "authenticates the user" do
      post "/auth/login", params: { email: user.email, password: user.password }
      expect(response).to have_http_status(200)
    end
  end
end