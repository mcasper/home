defmodule Budget.Jwt do
  use Joken.Config

  @impl true
  def token_config do
    default_claims(iss: "Auth")
  end
end
