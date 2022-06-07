defmodule SimpleKanbanPhxWeb.BoardView do
  use SimpleKanbanPhxWeb, :view
  alias SimpleKanbanPhxWeb.{BoardView, ColumnView}

  def render("index.json", %{boards: boards}) do
    %{data: render_many(boards, BoardView, "board.json")}
  end

  def render("show.json", %{board: board}) do
    #%{data: render_one(board, BoardView, "board.json")}
    %{data: render_one(board, BoardView, "board_all_data.json")}
  end

  def render("board.json", %{board: board}) do
    %{
      id: board.id,
      title: board.title,
      description: board.description
    }
  end

  def render("board_all_data.json", %{board: board}) do
    #%{data: render_one(board, BoardView, "board.json")}
    %{
      id: board.id,
      title: board.title,
      description: board.description,
      columns: render_many(board.columns, ColumnView, "column.json")
    }
  end
end
