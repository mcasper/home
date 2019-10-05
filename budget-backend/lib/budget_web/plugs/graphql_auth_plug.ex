defmodule BudgetWeb.GraphqlAuthPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case decode_jwt(conn) do
      {:ok, claims} ->
        user_id = get_user_id_from_claims(claims)
        assign(conn, :user_id, user_id)
        context = %{user_id: user_id}
        Absinthe.Plug.put_options(conn, context: context)

      {:error, err} ->
        IO.inspect(err)
        conn
    end
  end

  defp get_user_id_from_claims(%{"email" => email}) do
    Budget.Accounts.find_or_create_user(email).id
  end

  defp decode_jwt(conn) do
    case raw_token(conn) do
      nil ->
        {:error, "No session"}

      "" ->
        {:error, "No session"}

      token ->
        signer =
          Joken.Signer.create("ES256", %{
            "pem" => File.read!(System.get_env("JWT_PUBLIC_KEY_PATH"))
          })

        Budget.Jwt.verify_and_validate(token, signer)
    end
  end

  defp raw_token(conn) do
    if Map.has_key?(conn.req_cookies, "home_session") do
      conn.req_cookies["home_session"]
    else
      nil
    end
  end
end
