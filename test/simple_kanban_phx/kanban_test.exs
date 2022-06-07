defmodule SimpleKanbanPhx.KanbanTest do
  use SimpleKanbanPhx.DataCase

  alias SimpleKanbanPhx.Kanban

  describe "boards" do
    alias SimpleKanbanPhx.Kanban.Board

    import SimpleKanbanPhx.KanbanFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Kanban.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Kanban.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Board{} = board} = Kanban.create_board(valid_attrs)
      assert board.description == "some description"
      assert board.title == "some title"
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Kanban.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Board{} = board} = Kanban.update_board(board, update_attrs)
      assert board.description == "some updated description"
      assert board.title == "some updated title"
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Kanban.update_board(board, @invalid_attrs)
      assert board == Kanban.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Kanban.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Kanban.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Kanban.change_board(board)
    end
  end

  describe "columns" do
    alias SimpleKanbanPhx.Kanban.Column

    import SimpleKanbanPhx.KanbanFixtures

    @invalid_attrs %{position: nil, title: nil}

    test "list_columns/0 returns all columns" do
      column = column_fixture()
      assert Kanban.list_columns() == [column]
    end

    test "get_column!/1 returns the column with given id" do
      column = column_fixture()
      assert Kanban.get_column!(column.id) == column
    end

    test "create_column/1 with valid data creates a column" do
      valid_attrs = %{position: 42, title: "some title"}

      assert {:ok, %Column{} = column} = Kanban.create_column(valid_attrs)
      assert column.position == 42
      assert column.title == "some title"
    end

    test "create_column/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Kanban.create_column(@invalid_attrs)
    end

    test "update_column/2 with valid data updates the column" do
      column = column_fixture()
      update_attrs = %{position: 43, title: "some updated title"}

      assert {:ok, %Column{} = column} = Kanban.update_column(column, update_attrs)
      assert column.position == 43
      assert column.title == "some updated title"
    end

    test "update_column/2 with invalid data returns error changeset" do
      column = column_fixture()
      assert {:error, %Ecto.Changeset{}} = Kanban.update_column(column, @invalid_attrs)
      assert column == Kanban.get_column!(column.id)
    end

    test "delete_column/1 deletes the column" do
      column = column_fixture()
      assert {:ok, %Column{}} = Kanban.delete_column(column)
      assert_raise Ecto.NoResultsError, fn -> Kanban.get_column!(column.id) end
    end

    test "change_column/1 returns a column changeset" do
      column = column_fixture()
      assert %Ecto.Changeset{} = Kanban.change_column(column)
    end
  end

  describe "tasks" do
    alias SimpleKanbanPhx.Kanban.Task

    import SimpleKanbanPhx.KanbanFixtures

    @invalid_attrs %{description: nil, position: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Kanban.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Kanban.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{description: "some description", position: 42}

      assert {:ok, %Task{} = task} = Kanban.create_task(valid_attrs)
      assert task.description == "some description"
      assert task.position == 42
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Kanban.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{description: "some updated description", position: 43}

      assert {:ok, %Task{} = task} = Kanban.update_task(task, update_attrs)
      assert task.description == "some updated description"
      assert task.position == 43
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Kanban.update_task(task, @invalid_attrs)
      assert task == Kanban.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Kanban.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Kanban.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Kanban.change_task(task)
    end
  end
end
