require "rails_helper"

RSpec.describe MatchesController, type: :controller do
  let!(:match) { create(:match_with_3_users) }
  # let!(:match_2) { create(:match_with_3_users) }
  let!(:allen) { create(:user, {nickname: 'allen'}) }
  let!(:joe) { create(:user, {nickname: 'joe'}) }
  let!(:sam) { create(:user, {nickname: 'sam'}) }
  let!(:peq) { create(:user, {nickname: 'peq'}) }
  let!(:custom_match) { create(:match_custom, { users: [allen, joe, sam] }) }

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
      post :create, params: { match: { number_of_rounds: 5 }, nicknames: ['allen', 'joe', 'sam'] }
      expect( response ).to have_http_status(200)
    end

    it "returns the newly created match stats" do
      post :create, params: { match: { number_of_rounds: 5 }, nicknames: ['allen', 'joe', 'sam'] }
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
      post :create, params: { match: { number_of_rounds: 3 }, nicknames: ['allen', 'joe', 'intruder'] }
      expect( response ).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH#update' do
    it "returns an error if a user sent in params does not exist" do
      id = match.id
      patch :update, params: { id:, players: [{ nickname: "intruder", score: 4 }] }
      expected_response = "Couldn't find a player with this nickname: intruder"
      expect( response.body ).to eq(expected_response)
    end

    it "returns an error if a user sent in params is not playing in this match" do
      id = match.id
      patch :update, params: { id:, players: [{ nickname: "peq", score: 777 }] }
      expected_response = "Player with nickname [peq] is not a participant of this match"
      expect( response.body ).to eq(expected_response)
    end

    it "updates the users' scores" do
      id = custom_match.id
      players = [
        { nickname: "allen", score: 42 },
        { nickname: "joe", score: 21 },
        { nickname: "sam", score: 9 }
      ]
      patch :update, params: { id:, players: }
      user_scores = response.parsed_body["user_scores"]
      # Mapping user_scores to have a hash with nicknames as keys and scores as values (overkill, I know, but more convenient)
      mapped_user_scores = user_scores.map { |user| [user["user"].to_sym, user["score"]] }.to_h
      expect(mapped_user_scores).to eq({ allen: 42, joe: 21, sam: 9 })
    end
  end
end
