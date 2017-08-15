defmodule ApiUrlShortener.Router do
  use ApiUrlShortener.Web, :router

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

  scope "/", ApiUrlShortener do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/new/*url", ApiController, :shorten
    get "/*id", ApiController, :resolve_to_long_url
  end

  # Other scopes may use custom stacks.
  # scope "/api", ApiUrlShortener do
  #   pipe_through :api
  # end
end
