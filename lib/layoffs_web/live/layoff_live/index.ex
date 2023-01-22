defmodule LayoffsWeb.LayoffLive.Index do
  use LayoffsWeb, :live_view

  alias Layoffs.Cases

  @impl true
  def mount(_params, _session, socket) do
    {last_layoffs, callout} = Cases.get_last_layoff_with_callout()
    streaks = Cases.get_streaks()

    highest_count =
      Enum.reduce(streaks, 0, fn {_date, count}, acc ->
        max(count, acc)
      end)

    {:ok,
     assign(socket,
       page_title: callout,
       callout: callout,
       last_layoffs: last_layoffs,
       highest_count: highest_count,
       streaks: streaks
     )}
  end
end
