class ApplicationController < ActionController::Base
  before_action :ensure_valid_token

  def ensure_valid_token
    ecdsa = OpenSSL::PKey::EC.new(File.read(Rails.root.join("../auth/key.pem")))
    ecdsa.private_key = nil

    token = params[:key]

    begin
      decoded_token = JWT.decode(token, ecdsa, true, { algorithm: 'ES256' })
    rescue JWT::DecodeError => e
      redirect_to("#{ROOT_DOMAIN}/auth/login?returnTo=#{ROOT_DOMAIN}/recipes")
    end
  end
end
