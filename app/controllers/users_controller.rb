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
      raise ArgumentError, "User with nickname #{params[:nickname]} not found" if @user.nil?
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
      nicknames_exist?
      set_nicknames
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

  def nicknames_exist?
    raise ArgumentError, "No 'nicknames' key found in params" if params[:nicknames].blank?
  end

  def set_nicknames
    # Removes empty nicknames and duplicates from params
    params[:nicknames] = params[:nicknames].map(&:strip).reject(&:empty?).uniq
  end

  def nicknames_valid?
    # Ensures between 3 and 10 players were sent
    if params[:nicknames].length < 3 || params[:nicknames].length > 10
      raise ArgumentError, "#{params[:nicknames].length} players provided, there must be 3..10 players"
    end
  end

  def user_params
    params.require(:user).permit(:nickname)
  end
end
