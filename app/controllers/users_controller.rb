class UsersController < ApplicationController
  def index
    begin
      @users = User.all
      raise StandardError, "No users found" unless 0 < @users.length
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
    begin
      @user = User.find_by(nickname: params[:nickname])
      raise ArgumentError, "User with nickname #{params[:nickname]} not found"
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors
    else
      render json: @user.stats
    end
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
