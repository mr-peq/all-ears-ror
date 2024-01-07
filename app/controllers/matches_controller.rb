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
    # Expects both match params and an array of all participating players' nicknames
    begin
      nicknames_valid?
      users = params[:nicknames].map { |nickname| User.find_by!(nickname:) }
      @match = Match.create!(match_params)
      add_users_to_match(@match, users)
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors.message, status: :unprocessable_entity
    else
      render json: @match.stats
    end
  end

  def update
    begin
      @match = Match.find(params[:id])
      user_matches = update_user_matches
      user_matches.each(&:save!)
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors.message, status: :unprocessable_entity
    else
      render json: @match.stats
    end
  end


  private

  def nicknames_valid?
    # Nicknames param must exist, and there must be between 3 and 10 players
    if params[:nicknames].blank? || params[:nicknames].uniq.length < 3 || params[:nicknames].uniq.length > 10
      raise ArgumentError, "#{params[:nicknames].blank? ? 0 : params[:nicknames].uniq.length } players provided, there must be 3..10 players"
    end
  end

  def update_user_matches
    # Returns all the user_matches of the current match with updated scores. Will raise an error if:
    # - A given player is not found
    # - A given player is not included in the current match
    user_matches = []
    params[:players].each do |player|
      user = User.find_by(nickname: player[:nickname])
      raise ArgumentError, "Couldn't find a player with this nickname: #{player[:nickname]}" if user.nil?

      user_match = @match.user_matches.find_by(user:)
      raise ArgumentError, "Player with nickname [#{player[:nickname]}] is not a participant of this match" if user_match.nil?

      user_match.score = player[:score]
      user_matches << user_match
    end
    user_matches
  end

  def add_users_to_match(match, users)
    users.each do |user|
      UserMatch.create!(user:, match:)
    end
  end

  def match_params
    params.require(:match).permit(:number_of_rounds)
  end
end
