class MatchesController < ApplicationController
  def index
    begin
      @matches = Match.all
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors
    else
      @response = []
      @matches.each do |match|
        @response << match.stats
      end
      render json: @response
    end
  end

  def show
    begin
      @match = Match.find(params[:id])
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors, status: :unprocessable_entity
    else
      @response = @match.stats
      render json: @response
    end
  end

  def create
    # Expects both match params and a user nickname array of all the players
    begin
      @match = Match.create!(match_params)
      add_users_to_match(@match, params[:nicknames])
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors, status: :unprocessable_entity
    else
      render json: @match.stats
    end
  end


  private

  def add_users_to_match(match, nicknames)
    nicknames.each do |nickname|
      user = User.find_by(nickname:)
      UserMatch.create!(user:, match:)
    end
  end

  def match_params
    params.require(:match).permit(:number_of_rounds)
  end
end
