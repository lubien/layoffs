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
       streaks: streaks,
       selected_date: nil
     )}
  end

  @impl true
  def handle_event("show_layoffs_for_date", %{"date" => date_str}, socket) do
    date = Date.from_iso8601!(date_str)
    {:ok, datetime, 0} = DateTime.from_iso8601("#{date_str}T00:00:00Z")
    layoffs = Cases.list_layoffs_for_date(datetime)

    {:noreply,
     assign(socket, selected_date: %{date: date, count: Enum.count(layoffs), layoffs: layoffs})}
  end
end
