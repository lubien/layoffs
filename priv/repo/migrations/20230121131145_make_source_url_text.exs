defmodule Layoffs.Repo.Migrations.MakeSourceUrlText do
  use Ecto.Migration

  def change do
    alter table(:layoffs) do
      modify :source_url, :text, from: :string
    end
  end
end
