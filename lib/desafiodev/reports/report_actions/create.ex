defmodule Desafiodev.Reports.ReportActions.Create do
  alias Desafiodev.{Repo, Reports.Report}

  def call(params) do
    changeset = Report.changeset(%Report{}, params)
    Repo.insert(changeset)
  end
end
