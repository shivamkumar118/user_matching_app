class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update]

  def index
    users = User.all
    render_success(users.map { |user| UserSerializer.new(user).as_json }, 'Users retrieved successfully')
  end

  def show
    render_success(UserSerializer.new(@user).as_json, 'User retrieved successfully')
  end

  def update
    if @user.update(user_params)
      render_success(UserSerializer.new(@user).as_json, 'User updated successfully')
    else
      render_error('Update failed', @user.errors.full_messages)
    end
  end

  def profile
    render_success(UserSerializer.new(current_user).as_json, 'Profile retrieved successfully')
  end

  def update_profile
    if current_user.update(user_params)
      render_success(UserSerializer.new(current_user).as_json, 'Profile updated successfully')
    else
      render_error('Profile update failed', current_user.errors.full_messages)
    end
  end

  def matches
    # This will be implemented in the matching controller
    render_success(nil, 'Matches functionality moved to matching controller')
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_error('User not found', nil, :not_found)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :address, 
                                :bio, :employment_status, :about)
  end
end
