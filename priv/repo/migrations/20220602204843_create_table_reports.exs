defmodule Desafiodev.Repo.Migrations.CreateTableReports do
  use Ecto.Migration

  def change do
    create table(:reports, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cnab_transacations, :map

      timestamps()
    end
  end
end
