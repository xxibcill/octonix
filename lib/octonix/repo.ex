defmodule Octonix.Repo do
  use Ecto.Repo,
    otp_app: :octonix,
    adapter: Ecto.Adapters.Postgres
end
