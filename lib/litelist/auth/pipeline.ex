defmodule Litelist.Auth.Pipeline do
  @moduledoc """
  Guardian pipeline to test if a user is signed in. Uses the Guardian package.
  """
  use Guardian.Plug.Pipeline,
    otp_app: :litelist,
    error_handler: Litelist.Auth.ErrorHandler,
    module: Litelist.Auth.Guardian
  # If there is a session token, validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # If there is an authorization header, validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
