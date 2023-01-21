defmodule LayoffsWeb.CompanyLive.Show do
  use LayoffsWeb, :live_view

  alias Layoffs.Cases

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:company, Cases.get_company!(id))}
  end

  defp page_title(:show), do: "Show Company"
  defp page_title(:edit), do: "Edit Company"
end
