defmodule LayoffsWeb.CompanyLive.Index do
  use LayoffsWeb, :live_view

  alias Layoffs.Cases
  alias Layoffs.Cases.Company

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :companies, list_companies())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Company")
    |> assign(:company, Cases.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Company")
    |> assign(:company, %Company{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Companies")
    |> assign(:company, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    company = Cases.get_company!(id)
    {:ok, _} = Cases.delete_company(company)

    {:noreply, assign(socket, :companies, list_companies())}
  end

  defp list_companies do
    Cases.list_companies()
  end
end
