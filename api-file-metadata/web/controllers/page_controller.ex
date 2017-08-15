defmodule ApiFileMetadata.PageController do
  use ApiFileMetadata.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
