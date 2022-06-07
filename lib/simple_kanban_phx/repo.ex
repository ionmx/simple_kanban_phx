defmodule SimpleKanbanPhx.Repo do
  use Ecto.Repo,
    otp_app: :simple_kanban_phx,
    adapter: Ecto.Adapters.Postgres
end
