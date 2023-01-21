defmodule Layoffs.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :uid, :string

      timestamps()
    end

    create unique_index(:companies, [:uid])
  end
end
