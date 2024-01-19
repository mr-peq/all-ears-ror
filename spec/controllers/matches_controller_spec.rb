require "rails_helper"

RSpec.describe MatchesController, type: :controller do
  let!(:match) { create(:match_with_3_users) }
  let!(:match_2) { create(:match_with_3_users) }
  let!(:user_two) { create(:user, {nickname: 'alt_user2'}) }
  let!(:user_four) { create(:user, {nickname: 'alt_user4'}) }
  let!(:user_six) { create(:user, {nickname: 'alt_user6'}) }

  describe 'GET#index' do
    it "returns a 200 HTTP status" do
      get :index
      expect( response ).to have_http_status(200)
    end

    it "returns a list" do
      get :index
      expect( response.parsed_body ).to be_a Array
    end

    it "returns all matches" do
      get :index
      expect( response.parsed_body.length ).to eq(2)
    end
  end

  describe 'GET#show' do
    it "returns a 200 HTTP status when the id given is valid" do
      id = match.id
      get :show, params: { id: }
      expect( response ).to have_http_status(200)
    end

    it "returns :unprocessable_entity error when the id given is not valid" do
      id = match.id + 100
      get :show, params: { id: }
      expect( response ).to have_http_status(:unprocessable_entity)
    end

    it "returns match stats" do
      id = match.id
      get :show, params: { id: }
      expect( response.parsed_body.keys ).to include('id', 'number_of_rounds', 'user_scores')
    end
  end

  describe 'POST#create' do
    it "creates a new match if the params are correct" do
      post :create, params: { match: { number_of_rounds: 5 }, nicknames: ['alt_user2', 'alt_user4', 'alt_user6'] }
      expect( response ).to have_http_status(200)
    end

    it "returns the newly created match stats" do
      post :create, params: { match: { number_of_rounds: 5 }, nicknames: ['alt_user2', 'alt_user4', 'alt_user6'] }
      expect( response.parsed_body.keys ).to include('id', 'number_of_rounds', 'user_scores' )
    end
  end

  describe 'POST#create | Validations' do
    it "returns an error message if no players are sent in params" do
      post :create, params: { match: { number_of_rounds: 3 } }
      expected_response = "0 players provided, there must be 3..10 players"
      expect( response.body ).to eq(expected_response)
    end

    it "returns an error message if less than 3 players are sent in params" do
      post :create, params: { match: { number_of_rounds: 3 }, nicknames: ['allen'] }
      expected_response = "1 players provided, there must be 3..10 players"
      expect( response.body ).to eq(expected_response)
    end

    it "returns an error message if more than 10 players are sent in params" do
      post :create, params: { match: { number_of_rounds: 3 }, nicknames: ("a".."l").to_a }
      expected_response = "12 players provided, there must be 3..10 players"
      expect( response.body ).to eq(expected_response)
    end

    it "returns :unprocessable_entity error if a player sent in params does not exist" do
      post :create, params: { match: { number_of_rounds: 3 }, nicknames: ['user2', 'user4', 'intruder'] }
      expect( response ).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH#update' do
    it "returns an error if a user sent in params does not exist" do
      id = match.id
      patch :update, params: { id:, players: [{ nickname: "intruder", score: 4 }] }
      expected_response = "Couldn't find a player with this nickname: intruder"
      p response.body == expected_response
      expect( response.body ).to eq(expected_response)
    end

    it "returns an error if a user sent in params is not playing in this match" do
      id = match.id
      patch :update, params: { id:, players: [{ nickname: "alt_user2", score: 777 }] }
      expected_response = "Player with nickname [alt_user2] is not a participant of this match"
      expect( response.body ).to eq(expected_response)
    end

    it "updates the users' scores" do
      id = match.id
      allen_score = 42
      joe_score = 21
      sam_score = 9
      players = [
        { nickname: "user2", score: allen_score },
        { nickname: "user4", score: joe_score },
        { nickname: "user6", score: sam_score }
      ]
      patch :update, params: { id:, players: }
    end
  end
end
