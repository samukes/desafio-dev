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

    cnab_transacations = Enum.map_reduce(file_cnab_lines, [], &map_lines/2)

    change(changeset, %{cnab_transacations: cnab_transacations})
  end

  defp map_lines(line, acc) do
    {type, operation} = String.slice(line, 0..0) |> match_type()
    {:ok, date} = String.slice(line, 1..8) |> Timex.parse("{YYYY}{0M}{0D}")
    {value, _string} = String.slice(line, 9..18) |> Float.parse()
    cpf = String.slice(line, 19..29)
    card = String.slice(line, 30..41)
    {:ok, time} = String.slice(line, 42..47) |> Timex.parse("{h24}{0m}{0s}")
    owner = String.slice(line, 48..61)
    company = String.slice(line, 62..80)

    item =
      case Enum.find_index(acc, fn item -> item.owner == owner && item.company == company end) do
        nil ->
          get_map({type, date, operation, 0, value, cpf, card, time, owner, company})
          |> struct_acc(nil)

        index ->
          Enum.at(acc, item_index) |> struct_map() |> struct_acc(acc, index)
      end
  end

  defp match_type("1"), do: {"debito", :entrada}
  defp match_type("2"), do: {"boleto", :saida}
  defp match_type("3"), do: {"financiamento"}
  defp match_type("4"), do: {"credito", :entrada}
  defp match_type("5"), do: {"recebimento_emprestimo", :entrada}
  defp match_type("6"), do: {"vendas", :entrada}
  defp match_type("7"), do: {"recebimento_ted", :entrada}
  defp match_type("8"), do: {"recebimento_doc", :entrada}
  defp match_type("9"), do: {"aluguel", :saida}
  defp match_type(_), do: {"debito", :entrada}

  defp match_operation(:entrada, acc, value), do: acc + value
  defp match_operation(:saida, acc, value), do: acc - value

  defp get_map({type, date, operation, acc, value, cpf, card, time, owner, company}) do
    %{
      type: type,
      date: date,
      balance: match_operation(operation, acc, value),
      cpf: cpf,
      card: card,
      time: time,
      owner: owner,
      company: company
    }
  end

  defp struct_map(map) do
    get_map({
      map.type,
      map.date,
      operation,
      map.balance,
      value,
      map.cpf,
      map.card,
      map.time,
      map.owner,
      map.company
    })
  end

  defp struct_acc(map, acc, index \\ nil) do
    case index do
      nil ->
        [map]

      index ->
        Enum.map(acc, fn
          {item, ^index} -> ^map
          item -> item(nil)
        end)
    end
  end
end
