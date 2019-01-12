class ApplicationController < ActionController::Base
  before_action :ensure_valid_token

  def ensure_valid_token
    return true if signed_in?

    begin
      token = decode_jwt
      session[:user_name] = token.first.fetch("name")
    rescue JWT::DecodeError
      redirect_to("#{ROOT_DOMAIN}/auth/login?returnTo=#{ROOT_DOMAIN}/recipes")
    end
  end

  private

  def signed_in?
    session[:user_name].present?
  end

  def decode_jwt
    JWT.decode(params[:key], ecdsa_key, true, algorithm: "ES256")
  end

  def ecdsa_key
    OpenSSL::PKey::EC.new(File.read(Rails.root.join("..", "auth", ENV.fetch("JWT_KEY_PATH"))))
  end
end
