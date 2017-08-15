defmodule ApiFileMetadata.ApiController do
  use ApiFileMetadata.Web, :controller

  def get_file_size(conn, %{"search"=> %{"file" => %Plug.Upload{path: path}}}) do
    {:ok, %File.Stat{size: size}} = File.stat path
    json conn, %{size: size}
  end

  def get_file_size(conn, _) do
    json conn, %{error: "Invalid Request"}
  end
end
