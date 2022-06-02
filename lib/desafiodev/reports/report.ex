defmodule Desafiodev.Reports.Report do
  use Ecto.Schema
  import Ecto.Changeset

  alias Desafiodev.Reports.CnabTransaction
  alias Desafiodev.Reports.Report
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "reports" do
    field(:file_cnab, :string, virtual: true)
    embeds_many(:cnab_transactions, CnabTransaction)

    timestamps()
  end

  def changeset(%Report{} = struct, params) do
    struct
    |> cast(params, [:file_cnab])
    |> validate_required([:file_cnab])
    |> retrieve_information()
    |> cast_embed(:cnab_transactions, with: &CnabTransaction.changeset/2)
  end

  defp retrieve_information(%Changeset{changes: %{file_cnab: file_cnab}} = changeset) do
    file_cnab_lines = String.split(file_cnab, "\n")

    cnab_transacations = Enum.map(file_cnab_lines, &map_lines/1)

    change(changeset, %{cnab_transacations: cnab_transacations})
  end

  defp map_lines(line) do
    type = String.slice(line, 0..0) |> match_type()
    {:ok, date} = String.slice(line, 1..8) |> Timex.parse("{YYYY}{0M}{0D}")
    {value, _string} = String.slice(line, 9..18) |> Float.parse()
    cpf = String.slice(line, 19..29)
    card = String.slice(line, 30..41)
    {:ok, time} = String.slice(line, 42..47) |> Timex.parse("{h24}{0m}{0s}")
    owner = String.slice(line, 48..61)
    company = String.slice(line, 62..80)

    %{
      type: type,
      date: date,
      value: value,
      cpf: cpf,
      card: card,
      time: time,
      owner: owner,
      company: company
    }
  end

  defp match_type(type) do
    case type do
      _ -> :debito
    end
  end
end
