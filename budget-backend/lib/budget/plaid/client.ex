defmodule Budget.Plaid.Client do
  use Tesla

  plug Tesla.Middleware.JSON

  def exchange_token(public_token) do
    request_body = %{
      "client_id" => plaid_client_id(),
      "secret" => Application.get_env(:budget, :plaid_secret),
      "public_token" => public_token
    }

    case post(base_url() <> "/item/public_token/exchange", request_body) do
      {:ok, %Tesla.Env{status: 200, body: response_body}} ->
        {:ok, response_body}

      {:ok, %Tesla.Env{body: response_body}} ->
        {:error, response_body["error_message"]}

      {:error, %Tesla.Env{status: status, body: _response_body}} ->
        {:error, status}

      {:error, :econnrefused} ->
        {:error, "Connection refused"}
    end
  end

  def get_transactions(access_token, account_id) do
    today = Date.utc_today()

    request_body = %{
      "client_id" => plaid_client_id(),
      "secret" => Application.get_env(:budget, :plaid_secret),
      "access_token" => access_token,
      "start_date" => Date.to_string(Date.add(today, -30)),
      "end_date" => Date.to_string(today),
      "options" => %{
        "account_ids" => [account_id],
        "count" => 500
      }
    }

    case post(base_url() <> "/transactions/get", request_body) do
      {:ok, %Tesla.Env{status: 200, body: response_body}} ->
        {:ok, response_body}

      {:ok, %Tesla.Env{body: response_body}} ->
        {:error, response_body["error_message"]}

      {:error, %Tesla.Env{status: status, body: _response_body}} ->
        {:error, status}

      {:error, :econnrefused} ->
        {:error, "Connection refused"}
    end
  end

  def get_balances(access_token) do
    request_body = %{
      "client_id" => plaid_client_id(),
      "secret" => Application.get_env(:budget, :plaid_secret),
      "access_token" => access_token
    }

    case post(base_url() <> "/accounts/balance/get", request_body) do
      {:ok, %Tesla.Env{status: 200, body: response_body}} ->
        {:ok, response_body}

      {:ok, %Tesla.Env{body: response_body}} ->
        {:error, response_body["error_message"]}

      {:error, %Tesla.Env{status: status, body: _response_body}} ->
        {:error, status}

      {:error, :econnrefused} ->
        {:error, "Connection refused"}
    end
  end

  defp plaid_client_id do
    # Not secret
    "5c4cffbeca63910011f18dd8"
  end

  defp base_url do
    Application.get_env(:budget, :plaid_url)
  end
end
