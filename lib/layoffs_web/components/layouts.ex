defmodule LayoffsWeb.Layouts do
  use LayoffsWeb, :html

  embed_templates "layouts/*"

  def get_image_path([last_layoff | _rest]) do
    vsn = last_layoff.inserted_at |> to_string() |> URI.encode()
    "/image?vsn=#{vsn}"
  end

  def get_image_path(_last_layoffs) do
    "/image"
  end
end
