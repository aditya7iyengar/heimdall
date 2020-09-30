defmodule BifrostWeb.Router do
  use BifrostWeb, :router

  import Phoenix.LiveDashboard.Router
  import Plug.BasicAuth

  pipeline :private_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BifrostWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :basic_auth, Application.compile_env(:bifrost, :basic_auth)
  end

  pipeline :public_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BifrostWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # coveralls-ignore-start
  pipeline :api do
    plug :accepts, ["json"]
  end

  # coveralls-ignore-stop

  scope "/", BifrostWeb do
    pipe_through :private_browser

    live "/", PageLive, :index

    resources "/aesirs", AesirController, only: [:new, :create, :delete]
  end

  scope "/", BifrostWeb do
    pipe_through :public_browser

    live "/aesirs/:uuid", AesirLive, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", BifrostWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  scope "/" do
    pipe_through :private_browser
    live_dashboard "/dashboard", metrics: BifrostWeb.Telemetry
  end
end
