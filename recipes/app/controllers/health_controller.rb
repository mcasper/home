class HealthController < ApplicationController
  skip_before_action :ensure_valid_token, only: :show

  def show
    head(:ok)
  end
end
