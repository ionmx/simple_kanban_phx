defmodule SimpleKanbanPhx.Kanban do
  @moduledoc """
  The Kanban context.
  """

  import Ecto.Query, warn: false
  alias SimpleKanbanPhx.Repo
  alias SimpleKanbanPhx.Kanban.Board
  alias SimpleKanbanPhx.Kanban.Column
  alias SimpleKanbanPhx.Kanban.Task
  alias Ecto.Multi

  @doc """
  Returns the list of boards.

  ## Examples

      iex> list_boards()
      [%Board{}, ...]

  """
  def list_boards do
    Repo.all(Board)
  end

  # Returns a single board with columns and tasks.
  defp board_with_columns_and_tasks_query(id) do
    from b in Board,
      where: b.id == ^id,
      preload: [columns: ^columns_query()]
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_single_board!(123)
      %Board{}

      iex> get_single_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_single_board!(id), do: Repo.get!(Board, id)

  @doc """
  Gets a single board with columns and tasks.
  """
  def get_board!(id) do
    id
    |> board_with_columns_and_tasks_query()
    |> Repo.one!()
   end

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(attrs \\ %{}) do
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a board and add defaults columns.
  """
  def create_board_with_columns(attrs \\ %{}) do
    Multi.new
    |> Multi.insert(:board, Board.changeset(%Board{}, attrs))
    |> Ecto.Multi.insert(:todo, fn %{board: board} ->
      Ecto.build_assoc(board, :columns, title: "To Do", position: 0)
    end)
    |> Ecto.Multi.insert(:inproccess, fn %{board: board} ->
      Ecto.build_assoc(board, :columns, title: "In Proccess", position: 1)
    end)
    |> Ecto.Multi.insert(:done, fn %{board: board} ->
      Ecto.build_assoc(board, :columns, title: "Done", position: 2)
    end)
    |> Repo.transaction()
  end


  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  @doc """
  Returns the list of columns.

  ## Examples

      iex> list_columns()
      [%Column{}, ...]

  """
  def list_columns(board_id) do
    Repo.all(Column, board_id: board_id)
  end

  @doc """
  Gets a single column.

  Raises `Ecto.NoResultsError` if the Column does not exist.

  ## Examples

      iex> get_column!(123)
      %Column{}

      iex> get_column!(456)
      ** (Ecto.NoResultsError)

  """
  def get_column!(id), do: Repo.get!(Column, id)

  @doc """
  Creates a column.

  ## Examples

      iex> create_column(%{field: value})
      {:ok, %Column{}}

      iex> create_column(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_column(%Board{} = board, attrs \\ %{}) do
    col_query = from c in Column,
                 where: c.board_id == ^board.id

    max_pos = Repo.aggregate(col_query, :max, :position) || -1

    board
    |> Ecto.build_assoc(:columns)
    |> Column.changeset(Map.merge(attrs, %{"position" => max_pos + 1}))
    |> Repo.insert()
  end

  @doc """
  Updates a column.

  ## Examples

      iex> update_column(column, %{field: new_value})
      {:ok, %Column{}}

      iex> update_column(column, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_column(%Column{} = column, attrs) do
    column
    |> Column.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a column.

  ## Examples

      iex> delete_column(column)
      {:ok, %Column{}}

      iex> delete_column(column)
      {:error, %Ecto.Changeset{}}

  """
  def delete_column(%Column{} = column) do
    Repo.delete(column)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking column changes.

  ## Examples

      iex> change_column(column)
      %Ecto.Changeset{data: %Column{}}

  """
  def change_column(%Column{} = column, attrs \\ %{}) do
    Column.changeset(column, attrs)
  end

  # Query for columns
  defp columns_query do
    from c in Column,
      order_by: :position,
      preload: [tasks: ^tasks_query()]
  end

   @doc """
  Move a task to a column / position
  """
  def move_column(attrs) do
    column = get_column!(attrs["column"])

    # Update the other columns positions
    query_source_pos =
      from c in "columns",
      where: c.board_id == ^column.board_id,
      where: c.position > ^column.position,
      update: [inc: [position: -1]]
    Repo.update_all(query_source_pos, [])

    query_dest_pos =
      from c in "columns",
      where: c.board_id == ^column.board_id,
      where: c.position >= ^attrs["position"],
      update: [inc: [position: 1]]
    Repo.update_all(query_dest_pos, [])

    # Update column position
    query_task =
      from c in "columns",
      where: c.id == ^column.id,
      update: [set: [position: ^attrs["position"]]]
    Repo.update_all(query_task, [])

    %{ok: true}

  end

  # Query for tasks
  defp tasks_query() do
    from t in Task,
      order_by: :position
  end

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.
  """
  def create_task(%Column{} = column, attrs \\ %{}) do
    task_query = from t in Task,
                 where: t.column_id == ^column.id

    max_pos = Repo.aggregate(task_query, :max, :position) || -1

    column
    |> Ecto.build_assoc(:tasks)
    |> Task.changeset(Map.merge(attrs, %{"position" => max_pos + 1}))
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  @doc """
  Move a task to a column / position
  """
  def move_task(attrs) do

    task = get_task!(attrs["task"])

    # Update source positions
    query_source_pos =
      from t in "tasks",
      where: t.column_id == ^task.column_id,
      where: t.position > ^task.position,
      update: [inc: [position: -1]]
    Repo.update_all(query_source_pos, [])

    # Update destination positions
    query_dest_pos =
      from t in "tasks",
      where: t.column_id == ^attrs["destination"],
      where: t.position >= ^attrs["position"],
      update: [inc: [position: 1]]
    Repo.update_all(query_dest_pos, [])

    # Update task
    query_task =
      from t in "tasks",
      where: t.id == ^task.id,
      update: [set: [column_id: ^attrs["destination"], position: ^attrs["position"]]]
    Repo.update_all(query_task, [])

    %{ok: true}

  end
end
