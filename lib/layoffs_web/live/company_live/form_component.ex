defmodule LayoffsWeb.CompanyLive.FormComponent do
  use LayoffsWeb, :live_component

  alias Layoffs.Cases

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage company records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="company-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Name" />
        <.input field={{f, :uid}} type="text" label="Uid" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Company</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{company: company} = assigns, socket) do
    changeset = Cases.change_company(company)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"company" => company_params}, socket) do
    changeset =
      socket.assigns.company
      |> Cases.change_company(company_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"company" => company_params}, socket) do
    save_company(socket, socket.assigns.action, company_params)
  end

  defp save_company(socket, :edit, company_params) do
    case Cases.update_company(socket.assigns.company, company_params) do
      {:ok, _company} ->
        {:noreply,
         socket
         |> put_flash(:info, "Company updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_company(socket, :new, company_params) do
    case Cases.create_company(company_params) do
      {:ok, _company} ->
        {:noreply,
         socket
         |> put_flash(:info, "Company created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
