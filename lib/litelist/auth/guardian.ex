defmodule Litelist.Auth.Guardian do
  @moduledoc """
  Uses Guardian to inspect user token
  """
  use Guardian, otp_app: :litelist
  alias Litelist.Auth
  def subject_for_token(neighbor, _claims) do
    {:ok, to_string(neighbor.id)}
  end
  def resource_from_claims(claims) do
    neighbor = claims["sub"]
    |> Auth.get_neighbor!
    {:ok, neighbor}
    # If something goes wrong here return {:error, reason}
  end
end
