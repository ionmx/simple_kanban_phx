defmodule SimpleKanbanPhx.Kanban.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :description, :string
    field :title, :string
    has_many :columns, SimpleKanbanPhx.Kanban.Column, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
