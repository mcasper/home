require "rails_helper"

def valid_jwt_headers
  {
    "Cookie" => "home_session=eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiTWF0dCBDYXNwZXIifQ.sb8s5XeXm-BBnpeq1M2BiVwrl8iiu5UmR5oyxpc8xxcA-q6GxBpfLmfOgSP6z7Q95DG-QjOXbEc_ttqjrdqaAg",
  }
end

RSpec.describe "Authentication", type: :request do
  describe "unauthenticated requests" do
    it "returns a 302 to the auth service" do
      get("/recipes")
      expect(response).to have_http_status(:found)
    end
  end

  describe "authenticated requests" do
    it "returns a 200" do
      get("/recipes", headers: valid_jwt_headers)
      expect(response).to have_http_status(:ok)
    end

    it "persists your session after authenticating" do
      get("/recipes", headers: valid_jwt_headers)
      expect(response).to have_http_status(:ok)

      get("/recipes")
      expect(response).to have_http_status(:ok)
    end
  end
end
