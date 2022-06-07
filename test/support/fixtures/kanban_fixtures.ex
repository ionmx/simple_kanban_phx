defmodule SimpleKanbanPhx.KanbanFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SimpleKanbanPhx.Kanban` context.
  """

  @doc """
  Generate a board.
  """
  def board_fixture(attrs \\ %{}) do
    {:ok, board} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> SimpleKanbanPhx.Kanban.create_board()

    board
  end

  @doc """
  Generate a column.
  """
  def column_fixture(attrs \\ %{}) do
    {:ok, column} =
      attrs
      |> Enum.into(%{
        position: 42,
        title: "some title"
      })
      |> SimpleKanbanPhx.Kanban.create_column()

    column
  end

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        position: 42
      })
      |> SimpleKanbanPhx.Kanban.create_task()

    task
  end
end
