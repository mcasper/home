defmodule Budget.Plaid.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://sandbox.plaid.com"
  plug Tesla.Middleware.JSON

  def exchange_token(public_token) do
    request_body = %{
      "client_id" => "5c4cffbeca63910011f18dd8",
      "secret" => Application.get_env(:budget, :plaid_secret),
      "public_token" => public_token
    }

    case post("/item/public_token/exchange", request_body) do
      {:ok, %Tesla.Env{status: 200, body: response_body}} ->
        IO.inspect(response_body)
        {:ok, response_body}

      {:error, %Tesla.Env{status: status, body: _response_body}} ->
        {:error, status}
    end
  end

  def get_transactions(access_token) do
    request_body = %{
      "client_id" => "5c4cffbeca63910011f18dd8",
      "secret" => Application.get_env(:budget, :plaid_secret),
      "access_token" => access_token,
      "start_date" => "2019-01-01",
      "end_date" => "2019-01-25"
    }

    case post("/transactions/get", request_body) do
      {:ok, %Tesla.Env{status: 200, body: response_body}} ->
        IO.inspect(response_body)
        {:ok, response_body}

      {:error, %Tesla.Env{status: status, body: _response_body}} ->
        {:error, status}
    end
  end

  def get_balances(access_token) do
    request_body = %{
      "client_id" => "5c4cffbeca63910011f18dd8",
      "secret" => Application.get_env(:budget, :plaid_secret),
      "access_token" => access_token
    }

    case post("/accounts/balance/get", request_body) do
      {:ok, %Tesla.Env{status: 200, body: response_body}} ->
        IO.inspect(response_body)
        {:ok, response_body}

      {:error, %Tesla.Env{status: status, body: _response_body}} ->
        {:error, status}
    end
  end
end
