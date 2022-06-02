defmodule Desafiodev.Reports.CnabTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Desafiodev.Reports.CnabTransaction

  @required_fields [:type, :value, :cpf, :card, :time, :owner, :company]
  @derive {Jason.Encoder, only: @required_fields}

  embedded_schema do
    field :type, :string
    field :date, :naive_datetime
    field :balance, :float
    field :cpf, :string
    field :card, :string
    field :time, :naive_datetime
    field :owner, :string
    field :company, :string
  end

  def changeset(%CnabTransaction{} = struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields -- [:type])
    |> validate_inclusion(:type, [
      "debito",
      "boleto",
      "financiamento",
      "credito",
      "recebimento_emprestimo",
      "vendas",
      "recebimento_ted",
      "recebimento_doc",
      "aluguel"
    ])
  end
end
