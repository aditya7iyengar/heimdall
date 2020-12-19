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

    plug :put_secure_browser_headers,
         %{
           "content-security-policy" => "\
            default-src 'self';\
            script-src 'self' 'unsafe-inline' 'unsafe-eval';\
            style-src 'self' 'unsafe-inline' 'unsafe-eval' https://fonts.googleapis.com;\
            img-src 'self' 'unsafe-inline' 'unsafe-eval' data:;\
            font-src 'self' 'unsafe-inline' 'unsafe-eval' https://fonts.gstatic.com data:;\
          "
         }

    plug :basic_auth, Application.compile_env(:bifrost, :basic_auth)
  end

  pipeline :public_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BifrostWeb.LayoutView, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers,
         %{
           "content-security-policy" => "\
            default-src 'self';\
            script-src 'self' 'unsafe-inline' 'unsafe-eval';\
            style-src 'self' 'unsafe-inline' 'unsafe-eval' https://fonts.googleapis.com;\
            img-src 'self' 'unsafe-inline' 'unsafe-eval' data:;\
            font-src 'self' 'unsafe-inline' 'unsafe-eval' https://fonts.gstatic.com data:;\
          "
         }
  end

  pipeline :graphql_api do
    plug :accepts, ["json"]

    plug HeimdallQL
  end

  scope "/", BifrostWeb do
    pipe_through :private_browser

    live "/", PageLive, :index

    resources "/encrypted_messages", EncryptedMessageController, only: [:new, :create, :delete]
  end

  scope "/", BifrostWeb do
    pipe_through :public_browser

    live "/encrypted_messages/:id", EncryptedMessageLive, :show
  end

  scope "/api/graphql" do
    pipe_through [:graphql_api]

    forward "/", Absinthe.Plug, schema: HeimdallQL.Schema
  end

  # coveralls-ignore-start
  if Mix.env() == :dev do
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      default_url: "/api/graphql",
      schema: HeimdallQL.Schema,
      socket: BifrostWeb.UserSocket,
      interface: :advanced
  end

  # coveralls-ignore-stop

  # Enables LiveDashboard only for development
  scope "/" do
    pipe_through :private_browser
    live_dashboard "/dashboard", metrics: BifrostWeb.Telemetry
  end
end
