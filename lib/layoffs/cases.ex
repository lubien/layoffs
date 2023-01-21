defmodule Layoffs.Cases do
  @moduledoc """
  The Cases context.
  """

  import Ecto.Query, warn: false
  alias Layoffs.Repo

  alias Layoffs.Cases.Company
  alias Layoffs.Cases.Layoff

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Repo.all(Company)
  end

  def upsert_companies_by_names(names) do
    existing_companies = Repo.all(from c in Company, where: c.name in ^names)

    missing_companies =
      names
      |> Enum.filter(fn name ->
        Enum.all?(existing_companies, fn existing -> existing.name != name end)
      end)

    changesets =
      missing_companies
      |> Enum.map(fn name ->
        now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
        %{name: name, uid: name, inserted_at: now, updated_at: now}
      end)

    {_count, new_companies} = Repo.insert_all(Company, changesets, returning: true)

    existing_companies ++ new_companies
  end

  def upsert_layoffs(layoffs) do
    Repo.insert_all(Layoff, layoffs,
      conflict_target: [:uid],
      on_conflict: {:replace, [:inserted_at, :updated_at, :source_url]},
      returning: true
    )
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end

  @doc """
  Returns the list of layoffs.

  ## Examples

      iex> list_layoffs()
      [%Layoff{}, ...]

  """
  def list_layoffs do
    Repo.all(Layoff)
  end

  @doc """
  Gets a single layoff.

  Raises `Ecto.NoResultsError` if the Layoff does not exist.

  ## Examples

      iex> get_layoff!(123)
      %Layoff{}

      iex> get_layoff!(456)
      ** (Ecto.NoResultsError)

  """
  def get_layoff!(id), do: Repo.get!(Layoff, id)

  def get_last_layoff! do
    Layoff
    |> order_by([l], desc: l.inserted_at)
    |> limit(1)
    |> preload(:company)
    |> Repo.one!()
  end

  @doc """
  Creates a layoff.

  ## Examples

      iex> create_layoff(%{field: value})
      {:ok, %Layoff{}}

      iex> create_layoff(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_layoff(attrs \\ %{}) do
    %Layoff{}
    |> Layoff.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a layoff.

  ## Examples

      iex> update_layoff(layoff, %{field: new_value})
      {:ok, %Layoff{}}

      iex> update_layoff(layoff, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_layoff(%Layoff{} = layoff, attrs) do
    layoff
    |> Layoff.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a layoff.

  ## Examples

      iex> delete_layoff(layoff)
      {:ok, %Layoff{}}

      iex> delete_layoff(layoff)
      {:error, %Ecto.Changeset{}}

  """
  def delete_layoff(%Layoff{} = layoff) do
    Repo.delete(layoff)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking layoff changes.

  ## Examples

      iex> change_layoff(layoff)
      %Ecto.Changeset{data: %Layoff{}}

  """
  def change_layoff(%Layoff{} = layoff, attrs \\ %{}) do
    Layoff.changeset(layoff, attrs)
  end

  def get_last_layoff_with_callout do
    last_layoff = get_last_layoff!()
    callout = format_callout(last_layoff)
    {last_layoff, callout}
  end

  defp format_callout(last_layoff) do
    days = NaiveDateTime.diff(NaiveDateTime.utc_now(), last_layoff.inserted_at, :day)

    middle =
      case days do
        d when d == 1 ->
          "1 day"

        d ->
          "#{d} days"
      end

    "We are #{middle} without layoffs"
  end
end
