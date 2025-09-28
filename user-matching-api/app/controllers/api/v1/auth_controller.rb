class Api::V1::AuthController < ApplicationController
  before_action :authenticate_user_from_token!, only: [:logout]
  before_action :authenticate_user!, only: [:logout]

  def register
    user = User.new(user_params)
    
    if user.save
      render json: {
        status: 'success',
        message: 'User registered successfully',
        data: {
          user: UserSerializer.new(user).as_json,
          token: generate_jwt_token(user)
        }
      }, status: :created
    else
      render json: {
        status: 'error',
        message: 'Registration failed',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    
    if user&.valid_password?(params[:password])
      render json: {
        status: 'success',
        message: 'Login successful',
        data: {
          user: UserSerializer.new(user).as_json,
          token: generate_jwt_token(user)
        }
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'Invalid email or password'
      }, status: :unauthorized
    end
  end

  def logout
    # In a real application, you might want to blacklist the token
    # For now, we'll just return a success message
    render json: {
      status: 'success',
      message: 'Logged out successfully'
    }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, 
                                :first_name, :last_name, :phone, :address, 
                                :bio, :employment_status, :about)
  end

  def generate_jwt_token(user)
    payload = {
      user_id: user.id,
      email: user.email,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end
end
