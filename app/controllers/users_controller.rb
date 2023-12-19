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
      render json: @users
    end
  end

  def show
    @user = User.find_by(nickname: params[:nickname])
    render json: @user
  end

  def create
    begin
      @user = User.create!(nickname: params[:nickname])
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors, status: :unprocessable_entity
    else
      render json: @user
    end
  end
end
