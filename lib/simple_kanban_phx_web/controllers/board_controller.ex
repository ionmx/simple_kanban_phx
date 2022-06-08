defmodule SimpleKanbanPhxWeb.BoardController do
  use SimpleKanbanPhxWeb, :controller

  alias SimpleKanbanPhx.Kanban
  alias SimpleKanbanPhx.Kanban.Board

  action_fallback SimpleKanbanPhxWeb.FallbackController

  def index(conn, _params) do
    boards = Kanban.list_boards()
    render(conn, "index.json", boards: boards)
  end

  def create(conn, board_params) do
    cb = Kanban.create_board_with_columns(board_params)
    with {:ok, %{ board: board, done: _done, inproccess: _inproccess, todo: _todo}} <- cb do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.board_path(conn, :show, board))
      |> render("show_single.json", board: board)
    end
  end

  def show(conn, %{"id" => id}) do
    board = Kanban.get_board!(id)
    render(conn, "show.json", board: board, columns: board.columns)
  end

  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Kanban.get_board!(id)

    with {:ok, %Board{} = board} <- Kanban.update_board(board, board_params) do
      render(conn, "show.json", board: board)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Kanban.get_board!(id)

    with {:ok, %Board{}} <- Kanban.delete_board(board) do
      send_resp(conn, :no_content, "")
    end
  end
end
