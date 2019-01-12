class ApplicationController < ActionController::Base
  before_action :ensure_valid_token

  def ensure_valid_token
    if session[:user_name].present?
      return true
    end

    ecdsa = OpenSSL::PKey::EC.new(File.read(Rails.root.join("..", "auth", "key.pem")))
    ecdsa.private_key = nil

    token = params[:key]

    begin
      token = JWT.decode(token, ecdsa, true, algorithm: "ES256")
      session[:user_name] = token.first.fetch("name")
    rescue JWT::DecodeError
      redirect_to("#{ROOT_DOMAIN}/auth/login?returnTo=#{ROOT_DOMAIN}/recipes")
    end
  end
end
