defmodule Layoffs.LayoffsImporter do
  alias Layoffs.Cases

  def import_from_priv do
    {count, _imported_files} =
      list_files()
      |> Stream.map(&get_file/1)
      |> Stream.map(&prepare_entry/1)
      |> apply_company_ids()
      |> Cases.upsert_layoffs()

    IO.puts("Upserted #{count} files")
  end

  defp list_files do
    Path.relative("./priv/data/")
    |> Path.expand()
    |> File.ls!()
  end

  defp get_file(filename) do
    {filename,
     Path.relative("./priv/data/#{filename}")
     |> Path.expand()
     |> File.read!()
     |> Jason.decode!()}
  end

  defp prepare_entry({filename, row}) do
    inserted_at = NaiveDateTime.from_iso8601!(row["inserted_at"])
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    %{
      uid: filename,
      inserted_at: inserted_at,
      updated_at: now,
      source_url: row["source_url"],
      company: row["company"]
    }
  rescue
    e ->
      IO.puts("Failed to process #{filename}")
      raise e
  end

  defp apply_company_ids(entries) do
    company_ids_by_name =
      entries
      |> Enum.map(& &1.company)
      |> Enum.uniq()
      |> Cases.upsert_companies_by_names()
      |> Enum.map(&{&1.name, &1.id})
      |> Enum.into(%{})

    Enum.map(entries, fn entry ->
      entry
      |> Map.drop([:company])
      |> Map.put(:company_id, company_ids_by_name[entry.company])
    end)
  end

  # defp upsert_all(entries) do

  # end
end
