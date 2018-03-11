defmodule LitelistWeb.Router do
  use LitelistWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Litelist.Auth.Pipeline
    plug :current_neighbor
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug :current_neighbor
  end

  pipeline :current_neighbor do
    plug Litelist.Plugs.CurrentNeighbor
  end

  # Definitely logged in scope
  scope "/", LitelistWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/secret", PageController, :secret
    resources "/sales", ForSaleController, only: [:new, :create, :edit, :update, :delete]
    resources "/jobs", JobController, only: [:new, :create, :edit, :update, :delete]
    resources "/events", EventController, only: [:new, :create, :edit, :update, :delete]
  end

  scope "/", LitelistWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    post "/", PageController, :login
    post "/logout", PageController, :logout
    resources "/sales", ForSaleController, only: [:show, :index]
    resources "/jobs", JobController, only: [:show, :index]
    resources "/events", EventController, only: [:show, :index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", LitelistWeb do
  #   pipe_through :api
  # end
end
