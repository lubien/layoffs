defmodule LayoffsWeb.PageController do
  use LayoffsWeb, :controller

  alias Layoffs.Cases
  alias Layoffs.ImageGenerator

  def image(conn, _params) do
    {_last_layoff, callout} = Cases.get_last_layoff_with_callout()
    attribution = "days-without-layoffs.lubien.dev"
    image = ImageGenerator.generate_image(callout, attribution)

    conn
    |> put_resp_content_type("image/png")
    |> send_resp(200, image)
  end
end
