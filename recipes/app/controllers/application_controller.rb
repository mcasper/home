class ApplicationController < ActionController::Base
  before_action :ensure_valid_token

  def ensure_valid_token
    begin
      return true if signed_in?

      token = decode_jwt
      session[:user_name] = token.first.fetch("name")
    rescue JWT::DecodeError
      redirect_to("/auth/login?returnTo=#{ROOT_DOMAIN}/recipes")
    end
  end

  private

  def token_valid?
    !Jwt.new(claims: decode_jwt).expired?
  end

  def signed_in?
    session[:user_name].present?
  end

  def decode_jwt
    @decode_jwt ||= JWT.decode(home_session, ecdsa_key, true, algorithm: "ES256")
  end

  def home_session
    cookies["home_session"]
  end

  def ecdsa_key
    OpenSSL::PKey::EC.new(File.read(Rails.root.join("..", "auth", ENV.fetch("JWT_KEY_PATH"))))
  end
end
