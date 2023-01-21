defmodule LayoffsWeb.LayoffLive.FormComponent do
  use LayoffsWeb, :live_component

  alias Layoffs.Cases

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage layoff records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="layoff-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :uid}} type="text" label="Uid" />
        <.input field={{f, :source_url}} type="text" label="Source url" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Layoff</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{layoff: layoff} = assigns, socket) do
    changeset = Cases.change_layoff(layoff)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"layoff" => layoff_params}, socket) do
    changeset =
      socket.assigns.layoff
      |> Cases.change_layoff(layoff_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"layoff" => layoff_params}, socket) do
    save_layoff(socket, socket.assigns.action, layoff_params)
  end

  defp save_layoff(socket, :edit, layoff_params) do
    case Cases.update_layoff(socket.assigns.layoff, layoff_params) do
      {:ok, _layoff} ->
        {:noreply,
         socket
         |> put_flash(:info, "Layoff updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_layoff(socket, :new, layoff_params) do
    case Cases.create_layoff(layoff_params) do
      {:ok, _layoff} ->
        {:noreply,
         socket
         |> put_flash(:info, "Layoff created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
