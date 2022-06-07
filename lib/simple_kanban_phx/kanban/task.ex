defmodule SimpleKanbanPhx.Kanban.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :description, :string
    field :position, :integer
    belongs_to :column, SimpleKanbanPhx.Kanban.Column
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:description, :position])
    |> validate_required([:description, :position])
  end
end
