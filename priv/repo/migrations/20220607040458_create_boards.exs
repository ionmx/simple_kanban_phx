defmodule SimpleKanbanPhx.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :title, :string
      add :description, :text

      timestamps()
    end
  end
end
