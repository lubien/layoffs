defmodule Layoffs.Repo.Migrations.CreateLayoffs do
  use Ecto.Migration

  def change do
    create table(:layoffs) do
      add :uid, :string
      add :source_url, :string
      add :company_id, references(:companies, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:layoffs, [:uid])
    create index(:layoffs, [:company_id])
  end
end
