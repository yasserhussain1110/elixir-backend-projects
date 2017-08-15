defmodule ApiImageSearch.SearchTerm do
  use ApiImageSearch.Web, :model

  schema "search_terms" do
    field :term, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:term])
    |> validate_required([:term])
  end

  defimpl Poison.Encoder, for: ApiImageSearch.SearchTerm do
    def encode(model, opts) do
      model
        |> Map.take([:term, :inserted_at])
        |> Poison.Encoder.encode(opts)
    end
  end
end
