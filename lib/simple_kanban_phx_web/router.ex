defmodule SimpleKanbanPhxWeb.Router do
  use SimpleKanbanPhxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SimpleKanbanPhxWeb do
    pipe_through :api

    scope "/v1" do
      resources "/boards", BoardController, except: [:new, :edit] do
        post "/move-task", TaskController, :move_task, as: :move_task
        resources "/columns", ColumnController, except: [:new, :edit] do
          resources "/tasks", TaskController, except: [:new, :edit]
        end
      end
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: SimpleKanbanPhxWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
