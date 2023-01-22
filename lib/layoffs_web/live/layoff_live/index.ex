defmodule LayoffsWeb.LayoffLive.Index do
  use LayoffsWeb, :live_view

  alias Layoffs.Cases

  @impl true
  def mount(_params, _session, socket) do
    {last_layoffs, callout} = Cases.get_last_layoff_with_callout()
    streaks = Cases.get_streaks()

    {:ok,
     assign(socket,
       page_title: callout,
       callout: callout,
       last_layoffs: last_layoffs,
       streaks: streaks
     )}
  end
end
