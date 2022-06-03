defmodule Desafiodev.Reports do
  alias Desafiodev.Reports.ReportActions.Create, as: CreateReport

  defdelegate create_report(params), to: CreateReport, as: :call
end
