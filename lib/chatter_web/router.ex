defmodule ChatterWeb.Router do
  use ChatterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :unauthenticated do
    plug Guardian.Plug.Pipeline, module: Chatter.Guardian,
      error_handler: ChatterWeb.SessionController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureNotAuthenticated
  end

  pipeline :authenticated do
    plug Guardian.Plug.Pipeline, module: Chatter.Guardian,
      error_handler: ChatterWeb.SessionController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatterWeb do
    pipe_through [:browser, :unauthenticated] # Use the default browser stack
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:create]
    get "/", SessionController, :new
  end

  scope "/", ChatterWeb do
    pipe_through [:browser, :authenticated]
    resources "/users", UserController, only: [:edit, :update, :show, :index, :delete]
    resources "/sessions", SessionController, only: [:delete]
    get "/chat", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatterWeb do
  #   pipe_through :api
  # end
end
