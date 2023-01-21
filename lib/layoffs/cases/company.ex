defmodule Layoffs.Cases.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string
    field :uid, :string

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :uid])
    |> validate_required([:name, :uid])
    |> unique_constraint(:uid)
  end
end
