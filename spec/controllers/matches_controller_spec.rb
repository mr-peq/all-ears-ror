require "rails_helper"

RSpec.describe MatchesController, type: :controller do
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
      id = Match.last.id
      get :show, params: { id: }
      expect( response ).to have_http_status(200)
    end

    it "returns :unprocessable_entity error when the id given is not valid" do
      id = Match.last.id + 100
      get :show, params: { id: }
      expect( response ).to have_http_status(:unprocessable_entity)
    end

    it "returns match stats" do
      id = Match.last.id
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
end
