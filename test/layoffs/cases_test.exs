defmodule Layoffs.CasesTest do
  use Layoffs.DataCase

  alias Layoffs.Cases

  describe "companies" do
    alias Layoffs.Cases.Company

    import Layoffs.CasesFixtures

    @invalid_attrs %{name: nil, uid: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Cases.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Cases.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{name: "some name", uid: "some uid"}

      assert {:ok, %Company{} = company} = Cases.create_company(valid_attrs)
      assert company.name == "some name"
      assert company.uid == "some uid"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cases.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{name: "some updated name", uid: "some updated uid"}

      assert {:ok, %Company{} = company} = Cases.update_company(company, update_attrs)
      assert company.name == "some updated name"
      assert company.uid == "some updated uid"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Cases.update_company(company, @invalid_attrs)
      assert company == Cases.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Cases.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Cases.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Cases.change_company(company)
    end
  end

  describe "layoffs" do
    alias Layoffs.Cases.Layoff

    import Layoffs.CasesFixtures

    @invalid_attrs %{source_url: nil, uid: nil}

    test "list_layoffs/0 returns all layoffs" do
      layoff = layoff_fixture()
      assert Cases.list_layoffs() == [layoff]
    end

    test "get_layoff!/1 returns the layoff with given id" do
      layoff = layoff_fixture()
      assert Cases.get_layoff!(layoff.id) == layoff
    end

    test "create_layoff/1 with valid data creates a layoff" do
      valid_attrs = %{source_url: "some source_url", uid: "some uid"}

      assert {:ok, %Layoff{} = layoff} = Cases.create_layoff(valid_attrs)
      assert layoff.source_url == "some source_url"
      assert layoff.uid == "some uid"
    end

    test "create_layoff/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cases.create_layoff(@invalid_attrs)
    end

    test "update_layoff/2 with valid data updates the layoff" do
      layoff = layoff_fixture()
      update_attrs = %{source_url: "some updated source_url", uid: "some updated uid"}

      assert {:ok, %Layoff{} = layoff} = Cases.update_layoff(layoff, update_attrs)
      assert layoff.source_url == "some updated source_url"
      assert layoff.uid == "some updated uid"
    end

    test "update_layoff/2 with invalid data returns error changeset" do
      layoff = layoff_fixture()
      assert {:error, %Ecto.Changeset{}} = Cases.update_layoff(layoff, @invalid_attrs)
      assert layoff == Cases.get_layoff!(layoff.id)
    end

    test "delete_layoff/1 deletes the layoff" do
      layoff = layoff_fixture()
      assert {:ok, %Layoff{}} = Cases.delete_layoff(layoff)
      assert_raise Ecto.NoResultsError, fn -> Cases.get_layoff!(layoff.id) end
    end

    test "change_layoff/1 returns a layoff changeset" do
      layoff = layoff_fixture()
      assert %Ecto.Changeset{} = Cases.change_layoff(layoff)
    end
  end
end
