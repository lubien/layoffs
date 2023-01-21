defmodule Layoffs.CasesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Layoffs.Cases` context.
  """

  @doc """
  Generate a unique company uid.
  """
  def unique_company_uid, do: "some uid#{System.unique_integer([:positive])}"

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        name: "some name",
        uid: unique_company_uid()
      })
      |> Layoffs.Cases.create_company()

    company
  end

  @doc """
  Generate a unique layoff uid.
  """
  def unique_layoff_uid, do: "some uid#{System.unique_integer([:positive])}"

  @doc """
  Generate a layoff.
  """
  def layoff_fixture(attrs \\ %{}) do
    {:ok, layoff} =
      attrs
      |> Enum.into(%{
        source_url: "some source_url",
        uid: unique_layoff_uid()
      })
      |> Layoffs.Cases.create_layoff()

    layoff
  end
end
