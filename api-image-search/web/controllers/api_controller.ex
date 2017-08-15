defmodule ApiImageSearch.ApiController do
  use ApiImageSearch.Web, :controller

  alias ApiImageSearch.SearchTerm

  defp get_api_values(:key) do
    Application.get_env(:api_image_search, ApiImageSearch.Endpoint)[:key]
  end

  defp get_api_values(:cx) do
    Application.get_env(:api_image_search, ApiImageSearch.Endpoint)[:cx]
  end

  defp adjust_offset(offset) do
    offset
      |> String.to_integer
      |> Integer.floor_div(10)
      |> (fn x, y -> x * y end).(10)
      |> Integer.to_string
  end

  defp search_image_and_send(url, conn) do
    response = url
      |> HTTPoison.get
      |> elem(1)
      |> (fn api_result -> Poison.decode!(api_result.body)["results"] end).()
      |> Enum.map(fn decoded_result ->
          %{
            "unescapedUrl" => unescapedUrl,
            "originalContextUrl" => originalContextUrl,
            "contentNoFormatting" => contentNoFormatting,
            "tbUrl" => tbUrl
          } = decoded_result

          %{
            url: unescapedUrl,
            context: originalContextUrl,
            snippet: contentNoFormatting,
            thumbnail: tbUrl
          }
        end)
    json conn, response
  end

  defp create_search_url(search_term, offset) do
    "https://www.googleapis.com/customsearch/v1element?prettyPrint=false&hl=en&searchtype=image&num=10&"
      <> "key=#{get_api_values :key}&"
      <> "cx=#{get_api_values :cx}&"
      <> (if offset !== nil, do: "start=" <> adjust_offset(offset) <> "&", else: "")
      <> "q=#{search_term}";
  end

  defp insert_term_in_database(search_term) do
    changeset = SearchTerm.changeset(%SearchTerm{}, %{term: search_term})
    Repo.insert(changeset)
    search_term
  end

  def image_search(conn, %{"offset" => offset, "term" => [search_term]}) do
    search_term
      |> insert_term_in_database
      |> create_search_url(offset)
      |> search_image_and_send(conn)
  end

  def image_search(conn, %{"term" => [search_term]}) do
    search_term
      |> insert_term_in_database
      |> create_search_url(nil)
      |> search_image_and_send(conn)
  end

  def image_search(conn, %{"term" => []}) do
    conn |> put_status(400) |> json(%{error: "Term needed"})
  end

  def latest(conn, _param) do
    latest = Repo.all(
      from search_term in SearchTerm,
      order_by: [desc: search_term.inserted_at],
      limit: 10
    )

    json conn, latest
  end
end
