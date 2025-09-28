module AuthHelper
  def generate_jwt_token(user)
    payload = {
      user_id: user.id,
      email: user.email,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end

  def auth_headers(user)
    { 'Authorization' => "Bearer #{generate_jwt_token(user)}" }
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
  config.include AuthHelper, type: :controller
end 