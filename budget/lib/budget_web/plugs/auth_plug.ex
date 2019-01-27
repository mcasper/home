defmodule BudgetWeb.AuthPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case decode_jwt(conn) do
      {:ok, claims} ->
        assign(conn, :user_id, get_user_id_from_claims(claims))

      {:error, err} ->
        IO.inspect(err)

        conn
        |> Phoenix.Controller.redirect(
          external: "http://localhost:3000/auth/login?returnTo=http://localhost:3000/budget"
        )
        |> halt()
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
    conn.req_cookies["home_session"]
  end
end
