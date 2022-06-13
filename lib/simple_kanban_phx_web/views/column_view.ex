defmodule SimpleKanbanPhxWeb.ColumnView do
  use SimpleKanbanPhxWeb, :view
  alias SimpleKanbanPhxWeb.{ColumnView, TaskView}

  def render("index.json", %{columns: columns}) do
    %{data: render_many(columns, ColumnView, "column.json")}
  end

  def render("show_simple.json", %{column: column}) do
    %{data: %{
      id: column.id,
      title: column.title,
      position: column.position
    }}
  end

  def render("show.json", %{column: column}) do
    %{data: render_one(column, ColumnView, "column.json")}
  end

  def render("column.json", %{column: column}) do
    %{
      id: column.id,
      title: column.title,
      position: column.position,
      tasks: render_many(column.tasks, TaskView, "task.json")
    }
  end
end
