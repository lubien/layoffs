defmodule LayoffsWeb.LayoffLiveTest do
  use LayoffsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Layoffs.CasesFixtures

  @create_attrs %{source_url: "some source_url", uid: "some uid"}
  @update_attrs %{source_url: "some updated source_url", uid: "some updated uid"}
  @invalid_attrs %{source_url: nil, uid: nil}

  defp create_layoff(_) do
    layoff = layoff_fixture()
    %{layoff: layoff}
  end

  describe "Index" do
    setup [:create_layoff]

    test "lists all layoffs", %{conn: conn, layoff: layoff} do
      {:ok, _index_live, html} = live(conn, ~p"/layoffs")

      assert html =~ "Listing Layoffs"
      assert html =~ layoff.source_url
    end

    test "saves new layoff", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/layoffs")

      assert index_live |> element("a", "New Layoff") |> render_click() =~
               "New Layoff"

      assert_patch(index_live, ~p"/layoffs/new")

      assert index_live
             |> form("#layoff-form", layoff: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#layoff-form", layoff: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/layoffs")

      assert html =~ "Layoff created successfully"
      assert html =~ "some source_url"
    end

    test "updates layoff in listing", %{conn: conn, layoff: layoff} do
      {:ok, index_live, _html} = live(conn, ~p"/layoffs")

      assert index_live |> element("#layoffs-#{layoff.id} a", "Edit") |> render_click() =~
               "Edit Layoff"

      assert_patch(index_live, ~p"/layoffs/#{layoff}/edit")

      assert index_live
             |> form("#layoff-form", layoff: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#layoff-form", layoff: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/layoffs")

      assert html =~ "Layoff updated successfully"
      assert html =~ "some updated source_url"
    end

    test "deletes layoff in listing", %{conn: conn, layoff: layoff} do
      {:ok, index_live, _html} = live(conn, ~p"/layoffs")

      assert index_live |> element("#layoffs-#{layoff.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#layoff-#{layoff.id}")
    end
  end

  describe "Show" do
    setup [:create_layoff]

    test "displays layoff", %{conn: conn, layoff: layoff} do
      {:ok, _show_live, html} = live(conn, ~p"/layoffs/#{layoff}")

      assert html =~ "Show Layoff"
      assert html =~ layoff.source_url
    end

    test "updates layoff within modal", %{conn: conn, layoff: layoff} do
      {:ok, show_live, _html} = live(conn, ~p"/layoffs/#{layoff}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Layoff"

      assert_patch(show_live, ~p"/layoffs/#{layoff}/show/edit")

      assert show_live
             |> form("#layoff-form", layoff: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#layoff-form", layoff: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/layoffs/#{layoff}")

      assert html =~ "Layoff updated successfully"
      assert html =~ "some updated source_url"
    end
  end
end
