require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let!(:allen) { create(:user, {nickname: "allen"}) }
  let!(:joe) { create(:user, {nickname: "joe"}) }
  let!(:sam) { create(:user, {nickname: "sam"}) }
  let!(:peq) { create(:user, {nickname: "peq"}) }

  describe "GET#index" do
    it "returns a 200 HTTP status" do
      get :index
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

    it "returns the user's stats" do
      get :show, params: { nickname: allen.nickname }
      expected_attributes = ["id", "nickname", "total_matches", "total_points_scored", "matches"]
      expect( response.parsed_body.keys ).to eq(expected_attributes)
    end
  end

  describe "POST#create" do
    it "creates 3 new users if provided 3 new nicknames" do
      new_users_nicknames = ["julia", "bob", "fiona"]
      post :create, params: { nicknames: new_users_nicknames }
      response_users_nicknames = response.parsed_body.map { |user| user["nickname"] }
      expect( response_users_nicknames ).to eq(new_users_nicknames)
    end

    it "creates users that don't yet exist and retrieves the ones that already exist" do
      users_nicknames = [
        allen.nickname,
        joe.nickname,
        sam.nickname,
        peq.nickname,
        "julia",
        "bob",
        "fiona"
      ]
      post :create, params: { nicknames: users_nicknames }
      response_users_nicknames = response.parsed_body.map { |user| user["nickname"] }
      expect( response_users_nicknames ).to eq(users_nicknames)
    end

    it "returns an error if no params key was provided" do
      post :create, params: { fake_key: "fake key" }
      expect( response.parsed_body ).to eq("No 'nicknames' key found in params")
    end

    it "returns an error if less than 3 players nicknames were given" do
      users_nicknames = ["allen", "joe"]
      post :create, params: { nicknames: users_nicknames }
      expect( response.parsed_body ).to eq("#{users_nicknames.length} players provided, there must be 3..10 players")
    end

    it "returns an error if more than 10 players nicknames were given" do
      users_nicknames = ("a".."z").to_a
      post :create, params: { nicknames: users_nicknames }
      expect( response.parsed_body ).to eq("#{users_nicknames.length} players provided, there must be 3..10 players")
    end

    it "excludes duplicate nicknames if any in the params" do
      duplicate_users_nicknames = (["julia", "bob", "fiona"] * 2) # ruby == magic
      post :create, params: { nicknames: duplicate_users_nicknames }
      expect( response.parsed_body.length ).to eq(3)

      response_users_nicknames = response.parsed_body.map { |user| user["nickname"] }
      expect( response_users_nicknames ).to eq(duplicate_users_nicknames.uniq)
    end
  end
end
