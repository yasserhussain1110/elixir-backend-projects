defmodule ApiImageSearch.PageController do
  use ApiImageSearch.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
