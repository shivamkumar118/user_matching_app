class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  
  private

  def authenticate_user_from_token!
    authenticate_with_http_token do |token, options|
      begin
        decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
        user_id = decoded_token[0]['user_id']
        @current_user = User.find(user_id)
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: 'Invalid token' }, status: :unauthorized
        return
      end
    end
  end

  def current_user
    @current_user
  end

  def authenticate_user!
    unless current_user
      render json: { error: 'Authentication required' }, status: :unauthorized
    end
  end

  def render_success(data = nil, message = 'Success', status = :ok)
    render json: {
      status: 'success',
      message: message,
      data: data
    }, status: status
  end

  def render_error(message = 'Error', errors = nil, status = :unprocessable_entity)
    render json: {
      status: 'error',
      message: message,
      errors: errors
    }, status: status
  end
end
