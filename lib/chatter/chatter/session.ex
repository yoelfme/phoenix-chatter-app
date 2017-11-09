defmodule Chatter.Chatter.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatter.Chatter.Session


  schema "users2" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
