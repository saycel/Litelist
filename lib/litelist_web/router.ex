defmodule LitelistWeb.Router do
  use LitelistWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  pipeline :auth do
    :error_handler
    plug Litelist.Auth.Pipeline
    plug :current_neighbor
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, error_handler: Litelist.Auth.ErrorHandler
    plug :current_neighbor
  end

  pipeline :current_neighbor do
    plug Litelist.Plugs.CurrentNeighbor
  end

  pipeline :ensure_admin do
    plug Litelist.Plugs.EnsureAdmin, error_handler: Litelist.Auth.ErrorHandler
  end

  pipeline :error_handler do
    plug Guardian.Plug.Pipeline, error_handler: Litelist.Auth.ErrorHandler
  end

  # Definitely logged in scope
  scope "/", LitelistWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/dashboard", DashboardController, :index
    get "/dashboard/posts", DashboardController, :posts
    delete "/dashboard/posts", DashboardController, :delete_all
    delete "/dashboard/posts/delete/:id", DashboardController, :delete
    get "/dashboard/posts/export", DashboardController, :export_posts
    get "/dashboard/my_flagged_posts", DashboardController, :my_flagged_posts
    get "/dashboard/my_flagged_posts/export", DashboardController, :export_my_flagged_posts
    get "/dashboard/posts_i_flagged", DashboardController, :posts_i_flagged
    get "/dashboard/posts_i_flagged/export", DashboardController, :export_posts_i_flagged
    get "/dashboard/my_discussions", DashboardController, :my_discussions
    get "/dashboard/my_discussions/export", DashboardController, :export_my_discussions

    resources "/sales", ForSaleController, only: [:new, :create, :edit, :update, :delete]
    resources "/traffics", TrafficController, only: [:new, :create, :edit, :update, :delete]
    resources "/jobs", JobController, only: [:new, :create, :edit, :update, :delete]
    resources "/events", EventController, only: [:new, :create, :edit, :update, :delete]
    resources "/businesses", BusinessController, only: [:new, :create, :edit, :update, :delete]
    # resources "/emergency_info", EmergencyInformationController, only: [:new, :create, :edit, :update, :delete]
    resources "/discussions", DiscussionController, only: [:new, :create]
  end

  # Admin scope
  scope "/admin", LitelistWeb do
    pipe_through [:browser, :auth, :ensure_admin]

    get "/manage_posts", AdminController, :manage_posts
    get "/moderation-guidelines", FlagController, :guidelines
    get "/", AdminController, :index
    get "/posts", AdminController, :posts
    get "/settings", AdminController, :settings
    post "/settings", AdminController, :update_settings
    resources "/discussions", DiscussionController, only: [:edit, :update, :delete]
    resources "/moderation", FlagController, only: [:index, :delete, :edit, :update]
  end

  scope "/", LitelistWeb do
    pipe_through [:browser, :auth]
    get "/", PageController, :index

    get "/post2list", PageController, :information
    get "/login", PageController, :login
    post "/login", PageController, :post_login
    post "/logout", PageController, :logout
    
    get "/search", SearchController, :index
    resources "/traffics", TrafficController, only: [:show, :index]

    resources "/sales", ForSaleController, only: [:show, :index]
    resources "/jobs", JobController, only: [:show, :index]
    resources "/events", EventController, only: [:show, :index]
    resources "/businesses", BusinessController, only: [:show, :index]
    # resources "/emergency_info", EmergencyInformationController, only: [:show, :index]
    resources "/flags", FlagController, only: [:new, :show, :create]
    resources "/discussions", DiscussionController, only: [:index, :show]
    post "/discussion/create_comment", DiscussionController, :create_comment
    # get "/*url", PageController, :url_handler
  end

  # Other scopes may use custom stacks.
  # scope "/api", LitelistWeb do
  #   pipe_through :api
  # end
end
