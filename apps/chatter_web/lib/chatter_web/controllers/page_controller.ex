defmodule ChatterWeb.PageController do
  use ChatterWeb, :controller
  alias ChatterWeb.Session

  def index(conn, _params) do
    render conn, "index.html", %{token: Session.token(conn)}
  end
end
