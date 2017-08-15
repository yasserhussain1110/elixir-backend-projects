defmodule ApiUrlShortener.ApiController do
  use ApiUrlShortener.Web, :controller

  alias ApiUrlShortener.Url

  def resolve_to_long_url(conn, %{"id" => [id]}) do
    case Integer.parse id do
      {id, ""} -> conn |> try_to_send_long_url(id)
         _     -> conn |> put_status(400) |> json(%{error: "Invalid Format"})
    end
  end

  defp try_to_send_long_url(conn, id) do
    if id <= 2147483647 do # postgres max id size
      case Repo.get(Url, id) do
        %{url: url} -> redirect conn, external: url
        _ -> json conn, %{error: "url not found"}
      end
    else
      json conn, %{error: "Invalid Format"}
    end
  end

  def shorten(conn, _param) do
    url = String.replace conn.request_path, ~r{^/new/} , ""
    changeset = Url.changeset(%Url{}, %{url: url})
    case Repo.insert(changeset) do
      {:ok, post} ->
        json conn, %{
        "original_url" => url,
        "shortened_url" => "#{System.get_env("APP_URL") || "http://localhost:4000"}/#{post.id}"
        }
      {:error, _changeset} ->
        json conn, %{error: "Your url is invalid. Make sure it looks something like this - http://www.example.com"}
    end
  end
end
