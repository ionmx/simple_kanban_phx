defmodule SimpleKanbanPhxWeb.ColumnController do
  use SimpleKanbanPhxWeb, :controller

  alias SimpleKanbanPhx.Kanban
  alias SimpleKanbanPhx.Kanban.Column

  action_fallback SimpleKanbanPhxWeb.FallbackController

  def index(conn, params) do
    columns = Kanban.list_columns(params["board_id"])
    render(conn, "index.json", columns: columns)
  end

  def create(conn, %{"column" => column_params}) do
    with {:ok, %Column{} = column} <- Kanban.create_column(column_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.board_column_path(conn, :show, column))
      |> render("show.json", column: column)
    end
  end

  def show(conn, %{"id" => id}) do

    column = Kanban.get_column!(id)
    render(conn, "show.json", column: column)
  end

  def update(conn, %{"id" => id, "column" => column_params}) do
    column = Kanban.get_column!(id)

    with {:ok, %Column{} = column} <- Kanban.update_column(column, column_params) do
      render(conn, "show.json", column: column)
    end
  end

  def delete(conn, %{"id" => id}) do
    column = Kanban.get_column!(id)

    with {:ok, %Column{}} <- Kanban.delete_column(column) do
      send_resp(conn, :no_content, "")
    end
  end

  def move_column(conn, params) do
    Kanban.move_column(params)
    send_resp(conn, :no_content, "")
  end
end
