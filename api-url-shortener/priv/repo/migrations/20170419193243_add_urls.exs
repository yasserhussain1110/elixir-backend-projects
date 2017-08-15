defmodule ApiUrlShortener.Repo.Migrations.AddUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :url, :string

      timestamps()
    end
  end
end
