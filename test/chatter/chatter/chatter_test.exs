defmodule Chatter.ChatterTest do
  use Chatter.DataCase

  alias Chatter.Chatter

  describe "users2" do
    alias Chatter.Chatter.Session

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def session_fixture(attrs \\ %{}) do
      {:ok, session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chatter.create_session()

      session
    end

    test "list_users2/0 returns all users2" do
      session = session_fixture()
      assert Chatter.list_users2() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Chatter.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      assert {:ok, %Session{} = session} = Chatter.create_session(@valid_attrs)
      assert session.name == "some name"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chatter.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      assert {:ok, session} = Chatter.update_session(session, @update_attrs)
      assert %Session{} = session
      assert session.name == "some updated name"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Chatter.update_session(session, @invalid_attrs)
      assert session == Chatter.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Chatter.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Chatter.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Chatter.change_session(session)
    end
  end
end
