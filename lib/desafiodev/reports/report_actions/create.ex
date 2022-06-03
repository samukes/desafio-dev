defmodule Desafiodev.Reports.ReportActions.Create do
  alias Desafiodev.{Repo, Reports.Report}

  def call(params) do
    case File.read(params) do
      {:ok, content} -> Report.changeset(%Report{}, %{file_cnab: content}) |> Repo.insert()
      {:error, _reason} -> {:error, "error"}
    end
  end
end
