defmodule ApiImageSearch.ApiController do
  use ApiImageSearch.Web, :controller

  alias ApiImageSearch.SearchTerm

  defp get_api_value(key) do
    Application.get_env(:api_image_search, ApiImageSearch.Endpoint)[key]
  end

  defp get_search_result(url) do
    {:ok, apiResponse} = HTTPoison.get(url,
      ["Ocp-Apim-Subscription-Key": get_api_value(:BING_SUBSCRIPTION_KEY)],
      [ ssl: [{:versions, [:'tlsv1.2']}] ])

    apiResponse.body
      |> Poison.decode!
      |> Access.get("value")
      |> Enum.map(fn decoded_result ->
          %{
            "contentUrl" => contentUrl,
            "hostPageUrl" => hostPageUrl,
            "thumbnailUrl" => thumbnailUrl
          } = decoded_result

          %{
            url: contentUrl,
            context: hostPageUrl,
            thumbnail: thumbnailUrl
          }
        end)
  end

  defp create_search_url(search_term, offset) do
    "https://api.cognitive.microsoft.com/bing/v7.0/images/search?count=20&"
      <> "q=#{search_term}&"
      <> "offset=#{offset}"
  end

  defp insert_term_in_database(search_term) do
    changeset = SearchTerm.changeset(%SearchTerm{}, %{term: search_term})
    Repo.insert(changeset)
  end

  def image_search(conn, %{"offset" => offset, "term" => [search_term]}) do
    search_result = search_term
      |> create_search_url(offset)
      |> get_search_result

    return_val = json conn, search_result
    insert_term_in_database(search_term)
    return_val
  end

  def image_search(conn, %{"term" => [search_term]}) do
    search_result = search_term
      |> create_search_url(0)
      |> get_search_result

    return_val = json conn, search_result
    insert_term_in_database(search_term)
    return_val
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
