defmodule LayoffsWeb.LayoffLive.Index do
  use LayoffsWeb, :live_view

  alias Layoffs.Cases

  @impl true
  def mount(_params, _session, socket) do
    {last_layoff, callout} = Cases.get_last_layoff_with_callout()
    {:ok, assign(socket, page_title: callout, callout: callout, last_layoff: last_layoff)}
  end
end
