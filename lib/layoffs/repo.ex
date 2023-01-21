defmodule Layoffs.Repo do
  use Ecto.Repo,
    otp_app: :layoffs,
    adapter: Ecto.Adapters.Postgres
end
