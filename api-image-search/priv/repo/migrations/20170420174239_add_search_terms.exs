defmodule ApiImageSearch.Repo.Migrations.AddSearchTerms do
  use Ecto.Migration

  def change do
    create table(:search_terms) do
      add :term, :string

      timestamps()
    end
  end
end
