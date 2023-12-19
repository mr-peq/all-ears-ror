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
    begin
      @match = Match.create!(match_params)
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors, status: :unprocessable_entity
    else
      render json: @match
    end
  end


  private

  def match_params
    params.require(:match).permit(:number_of_rounds)
  end
end
