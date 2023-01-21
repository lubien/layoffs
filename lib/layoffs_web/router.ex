defmodule LayoffsWeb.Router do
  use LayoffsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LayoffsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LayoffsWeb do
    pipe_through :browser

    # live "/companies", CompanyLive.Index, :index
    # live "/companies/new", CompanyLive.Index, :new
    # live "/companies/:id/edit", CompanyLive.Index, :edit

    # live "/companies/:id", CompanyLive.Show, :show
    # live "/companies/:id/show/edit", CompanyLive.Show, :edit

    live "/", LayoffLive.Index, :index
    get "/image", PageController, :image
    # live "/layoffs/new", LayoffLive.Index, :new
    # live "/layoffs/:id/edit", LayoffLive.Index, :edit

    # live "/layoffs/:id", LayoffLive.Show, :show
    # live "/layoffs/:id/show/edit", LayoffLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", LayoffsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:layoffs, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LayoffsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
