defmodule Chatter.Repo.Migrations.CreateUsers2 do
  use Ecto.Migration

  def change do
    create table(:users2) do
      add :name, :string

      timestamps()
    end

  end
end
