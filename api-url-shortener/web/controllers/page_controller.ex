defmodule ApiUrlShortener.PageController do
  use ApiUrlShortener.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
