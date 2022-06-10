defmodule SimpleKanbanPhxWeb.TaskController do
  use SimpleKanbanPhxWeb, :controller

  alias SimpleKanbanPhx.Kanban
  alias SimpleKanbanPhx.Kanban.Task

  action_fallback SimpleKanbanPhxWeb.FallbackController

  def index(conn, _params) do
    tasks = Kanban.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn,task_params) do
    column = Kanban.get_column!(task_params["column_id"])
    with {:ok, %Task{} = task} <- Kanban.create_task(column, task_params) do
      conn
      |> put_status(:created)
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Kanban.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Kanban.get_task!(id)

    with {:ok, %Task{} = task} <- Kanban.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Kanban.get_task!(id)

    with {:ok, %Task{}} <- Kanban.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end

  def move_task(conn, params) do
    Kanban.move_task(params)
    send_resp(conn, :no_content, "")
  end
end
