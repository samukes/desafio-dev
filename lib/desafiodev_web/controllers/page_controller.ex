defmodule DesafiodevWeb.PageController do
  use DesafiodevWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
