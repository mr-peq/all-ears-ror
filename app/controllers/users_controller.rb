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
      nicknames_valid?
      @users = []
      params[:nicknames].each do |nickname|
        user = User.find_or_create_by!(nickname:)
        @users << user
      end
    rescue => exception
      @errors = exception
    end

    if @errors
      render json: @errors, status: :unprocessable_entity
    else
      render json: @users
    end
  end


  private

  def nicknames_valid?
    # Nicknames param must exist, and there must be between 3 and 10 players
    if params[:nicknames].blank? || params[:nicknames].uniq.length < 3 || params[:nicknames].uniq.length > 10
      raise ArgumentError, "#{params[:nicknames].blank? ? 0 : params[:nicknames].uniq.length } players provided, there must be 3..10 players"
    # Nicknames param mustn't contain an empty ("") nickname
    elsif params[:nicknames].include?("")
      raise ArgumentError, "Nicknames provided contains an empty nickname"
    end
  end

  def user_params
    params.require(:user).permit(:nickname)
  end
end
