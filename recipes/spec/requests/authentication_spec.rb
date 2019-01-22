require "rails_helper"

def valid_jwt_headers
  {
    # Expires at 2019-01-23T04:23:43.116Z
    "Cookie" => "home_session=eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiTWF0dCBDYXNwZXIiLCJleHAiOjE1NDg3MzU4MjIsImlzcyI6IkF1dGgifQ.qWhKL8e1cMMBUP8pormspJl7bRUzdkbTJWya4ceTweEWPTRJaKkxbjrHCXjuZRCDkljgP13iJ47YFq0gCcQp8Q",
  }
end

def expired_jwt_headers
  {
    "Cookie" => "home_session=eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiTWF0dCBDYXNwZXIiLCJleHAiOjE1NDgxMzA3NjgsImlzcyI6IkF1dGgifQ.C3UTn_j1e7gVnnWaVG422kD1QAGv_ZWqvoBXjd2z1YWAfBozp-x0PcdKlTRUXrMCSgo5spbYUg5kk-pmUdOogQ",
  }
end

RSpec.describe "Authentication", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  describe "unauthenticated requests" do
    it "returns a 302 to the auth service" do
      get("/recipes")
      expect(response).to have_http_status(:found)
    end
  end

  describe "authenticated requests" do
    it "returns a 200" do
      travel_to(Time.zone.local(2019, 1, 24, 0, 0, 0)) do
        get("/recipes", headers: valid_jwt_headers)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "expiration" do
    it "enforces the expiration time in the JWT on the first request" do
      travel_to(Time.zone.local(2019, 1, 24, 0, 0, 0)) do
        get("/recipes", headers: expired_jwt_headers)
        expect(response).to have_http_status(:found)
      end
    end

    it "enforces the expiration time in the JWT on subsequent requests" do
      travel_to(Time.zone.local(2019, 1, 24, 0, 0, 0)) do
        get("/recipes", headers: valid_jwt_headers)
        expect(response).to have_http_status(:ok)

        get("/recipes", headers: expired_jwt_headers)
        expect(response).to have_http_status(:found)
      end
    end
  end
end
