defmodule SimpleKanbanPhxWeb.ColumnController do
  use SimpleKanbanPhxWeb, :controller

  alias SimpleKanbanPhx.Kanban
  alias SimpleKanbanPhx.Kanban.Column

  action_fallback SimpleKanbanPhxWeb.FallbackController

  def index(conn, params) do
    columns = Kanban.list_columns(params["board_id"])
    render(conn, "index.json", columns: columns)
  end

  def create(conn, column_params) do
    board = Kanban.get_single_board!(column_params["board_id"])
    with {:ok, %Column{} = column} <- Kanban.create_column(board, column_params) do
      conn
      |> put_status(:created)
      |> render("show_simple.json", column: column)
    end
  end

  def show(conn, %{"id" => id}) do

    column = Kanban.get_column!(id)
    render(conn, "show.json", column: column)
  end

  def update(conn, params) do
    column = Kanban.get_column!(params["id"])

    with {:ok, %Column{} = column} <- Kanban.update_column(column, params) do
      render(conn, "show_simple.json", column: column)
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
