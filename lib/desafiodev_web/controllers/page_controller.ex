defmodule DesafiodevWeb.PageController do
  use DesafiodevWeb, :controller

  alias Desafiodev.Reports

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def insert(conn, %{"cnab_transactions" => %{"file_cnab" => %Plug.Upload{path: path}}}) do
    case Reports.create_report(path) do
      {:ok, report} -> render(conn, "show.html", report: report)
      {:error, _reason} -> %{error: "error"}
    end
  end
end
