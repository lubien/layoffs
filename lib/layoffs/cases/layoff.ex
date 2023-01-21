defmodule Layoffs.Cases.Layoff do
  use Ecto.Schema
  import Ecto.Changeset

  schema "layoffs" do
    field :source_url, :string
    field :uid, :string

    belongs_to :company, Layoffs.Cases.Company

    timestamps()
  end

  @doc false
  def changeset(layoff, attrs) do
    layoff
    |> cast(attrs, [:uid, :source_url])
    |> validate_required([:uid, :source_url])
    |> unique_constraint(:uid)
  end
end
