require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    context "with valid params" do
      let(:valid_params) { { user: { email: "test@example.com", password: "password" } } }

      it "creates a new user" do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "returns a success response with user JSON" do
        post :create, params: valid_params
        expect(response).to be_successful
        expect(response.body).to include("test@example.com")
      end

      it "sets the session token" do
        post :create, params: valid_params
        expect(session[:token]).not_to be_nil
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { user: { email: "", password: "password" } } }

      it "does not create a new user" do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)
      end
    end
  end

  describe "POST #login" do
    let!(:user) { User.create(email: "test@example.com", password: "password") }

    context "with valid credentials" do
      let(:valid_credentials) { { email: "test@example.com", password: "password" } }

      it "returns the user and token in JSON" do
        post :login, params: valid_credentials
        expect(response).to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response["user"]["email"]).to eq("test@example.com")
        expect(json_response["token"]).not_to be_nil
      end

      it "sets the session token" do
        post :login, params: valid_credentials
        expect(session[:token]).not_to be_nil
      end
    end

    context "with invalid credentials" do
      let(:invalid_credentials) { { email: "test@example.com", password: "wrongpassword" } }

      it "returns an unauthorized response with an error message" do
        post :login, params: invalid_credentials
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include("Invalid email or password")
      end

      it "does not set the session token" do
        post :login, params: invalid_credentials
        expect(session[:token]).to be_nil
      end
    end
  end
end
