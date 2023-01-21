defmodule LayoffsWeb.CompanyLiveTest do
  use LayoffsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Layoffs.CasesFixtures

  @create_attrs %{name: "some name", uid: "some uid"}
  @update_attrs %{name: "some updated name", uid: "some updated uid"}
  @invalid_attrs %{name: nil, uid: nil}

  defp create_company(_) do
    company = company_fixture()
    %{company: company}
  end

  describe "Index" do
    setup [:create_company]

    test "lists all companies", %{conn: conn, company: company} do
      {:ok, _index_live, html} = live(conn, ~p"/companies")

      assert html =~ "Listing Companies"
      assert html =~ company.name
    end

    test "saves new company", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/companies")

      assert index_live |> element("a", "New Company") |> render_click() =~
               "New Company"

      assert_patch(index_live, ~p"/companies/new")

      assert index_live
             |> form("#company-form", company: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#company-form", company: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/companies")

      assert html =~ "Company created successfully"
      assert html =~ "some name"
    end

    test "updates company in listing", %{conn: conn, company: company} do
      {:ok, index_live, _html} = live(conn, ~p"/companies")

      assert index_live |> element("#companies-#{company.id} a", "Edit") |> render_click() =~
               "Edit Company"

      assert_patch(index_live, ~p"/companies/#{company}/edit")

      assert index_live
             |> form("#company-form", company: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#company-form", company: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/companies")

      assert html =~ "Company updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes company in listing", %{conn: conn, company: company} do
      {:ok, index_live, _html} = live(conn, ~p"/companies")

      assert index_live |> element("#companies-#{company.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#company-#{company.id}")
    end
  end

  describe "Show" do
    setup [:create_company]

    test "displays company", %{conn: conn, company: company} do
      {:ok, _show_live, html} = live(conn, ~p"/companies/#{company}")

      assert html =~ "Show Company"
      assert html =~ company.name
    end

    test "updates company within modal", %{conn: conn, company: company} do
      {:ok, show_live, _html} = live(conn, ~p"/companies/#{company}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Company"

      assert_patch(show_live, ~p"/companies/#{company}/show/edit")

      assert show_live
             |> form("#company-form", company: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#company-form", company: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/companies/#{company}")

      assert html =~ "Company updated successfully"
      assert html =~ "some updated name"
    end
  end
end
