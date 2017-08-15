defmodule ApiUrlShortener.Url do
  use ApiUrlShortener.Web, :model

  schema "urls" do
    field :url, :string
    timestamps()
  end

  def validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{IO.inspect msg}"}]
      end
    end
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url])
    |> validate_url(:url, message: "Invalid Url")
    |> validate_required([:url])
  end
end
