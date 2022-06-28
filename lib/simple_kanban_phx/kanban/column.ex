defmodule SimpleKanbanPhx.Kanban.Column do
  use Ecto.Schema
  import Ecto.Changeset

  schema "columns" do
    field :position, :integer
    field :title, :string
    belongs_to :board, SimpleKanbanPhx.Kanban.Board
    has_many :tasks, SimpleKanbanPhx.Kanban.Task, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(column, attrs) do
    column
    |> cast(attrs, [:title, :position])
    |> validate_required([:title, :position])
  end
end
