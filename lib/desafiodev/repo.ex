defmodule Desafiodev.Repo do
  use Ecto.Repo,
    otp_app: :desafiodev,
    adapter: Ecto.Adapters.Postgres
end
