defmodule Layoffs.ImageGenerator do
  def generate_image(top, bottom) do
    {output, 0} =
      System.cmd("convert", [
        "-background",
        "#333333",
        "-fill",
        "white",
        "-font",
        "Helvetica",
        "-pointsize",
        "56",
        # [1]
        "label:#{top}",
        "-fill",
        "grey",
        "-font",
        "Helvetica-Oblique",
        "-pointsize",
        "32",
        # [2]
        "label:#{bottom}",
        "-append",
        "-background",
        "#333333",
        "-gravity",
        "center",
        "-extent",
        "1200x630",
        # [3]
        "png:-"
      ])

    output
  end
end
