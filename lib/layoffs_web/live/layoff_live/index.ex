defmodule LayoffsWeb.LayoffLive.Index do
  use LayoffsWeb, :live_view

  alias Layoffs.Cases

  @impl true
  def mount(_params, _session, socket) do
    last_layoff = Cases.get_last_layoff!()
    callout = format_callout(last_layoff)
    {:ok, assign(socket, callout: callout, last_layoff: last_layoff)}
  end

  def format_callout(last_layoff) do
    days = NaiveDateTime.diff(NaiveDateTime.utc_now(), last_layoff.inserted_at, :day)

    middle =
      case days do
        d when d == 1 ->
          "1 day"

        d ->
          "#{d} days"
      end

    "We are #{middle} without layoffs"
  end
end
