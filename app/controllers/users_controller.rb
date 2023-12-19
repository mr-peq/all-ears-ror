class UsersController < ApplicationController
  def index
    begin
      @users = User.all
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors
    else
      @response = []
      @users.each do |user|
        @response << user.stats
      end
      render json: @response
    end
  end

  def show
    user = User.find_by(nickname: params[:nickname])
    @response = user.stats
    render json: @response
  end

  def create
    begin
      @user = User.create!(user_params)
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors, status: :unprocessable_entity
    else
      render json: @user
    end
  end


  private

  def user_params
    params.require(:user).permit(:nickname)
  end
end
