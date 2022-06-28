defmodule SimpleKanbanPhx.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :text
      add :position, :integer
      add :column_id, references(:columns, on_delete: :delete_all)

      timestamps()
    end

    create index(:tasks, [:column_id])
  end
end
