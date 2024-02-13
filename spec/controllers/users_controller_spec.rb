require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let!(:allen) { create(:user, {nickname: "allen"}) }
  let!(:joe) { create(:user, {nickname: "joe"}) }
  let!(:sam) { create(:user, {nickname: "sam"}) }
  let!(:peq) { create(:user, {nickname: "peq"}) }

  describe "GET#index" do
    it "returns a 200 HTTP status" do
      get :index
      p response.parsed_body
      expect( response ).to have_http_status(200)
    end

    it "returns a list" do
      get :index
      expect( response.parsed_body ).to be_a Array
    end

    it "returns all users" do
      get :index
      expect( response.parsed_body.length ).to eq(4)
    end

    it "returns exactly the users in the database" do
      get :index
      created_users_nicknames = [allen, joe, sam, peq].map(&:nickname)
      response_users_nicknames = response.parsed_body.map { |user| user["nickname"] }
      expect( response_users_nicknames ).to eq(created_users_nicknames)
    end
  end

  describe "GET#show" do
    it "returns the user with the provided nickname" do
      get :show, params: { nickname: allen.nickname }
      expect( response.parsed_body["nickname"] ).to eq(allen.nickname)
    end

    it "returns an error if no user was found with the provided nickname" do
      not_a_user_nickname = "intruder"
      get :show, params: { nickname: not_a_user_nickname }
      expect( response.parsed_body ).to eq("User with nickname #{not_a_user_nickname} not found")
    end
  end
end
