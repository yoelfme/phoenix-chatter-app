defmodule ChatterWeb.SessionControllerTest do
  use ChatterWeb.ConnCase

  alias Chatter.Chatter

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:session) do
    {:ok, session} = Chatter.create_session(@create_attrs)
    session
  end

  describe "index" do
    test "lists all users2", %{conn: conn} do
      conn = get conn, session_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users2"
    end
  end

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200) =~ "New Session"
    end
  end

  describe "create session" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, session_path(conn, :create), session: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == session_path(conn, :show, id)

      conn = get conn, session_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Session"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, session_path(conn, :create), session: @invalid_attrs
      assert html_response(conn, 200) =~ "New Session"
    end
  end

  describe "edit session" do
    setup [:create_session]

    test "renders form for editing chosen session", %{conn: conn, session: session} do
      conn = get conn, session_path(conn, :edit, session)
      assert html_response(conn, 200) =~ "Edit Session"
    end
  end

  describe "update session" do
    setup [:create_session]

    test "redirects when data is valid", %{conn: conn, session: session} do
      conn = put conn, session_path(conn, :update, session), session: @update_attrs
      assert redirected_to(conn) == session_path(conn, :show, session)

      conn = get conn, session_path(conn, :show, session)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, session: session} do
      conn = put conn, session_path(conn, :update, session), session: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Session"
    end
  end

  describe "delete session" do
    setup [:create_session]

    test "deletes chosen session", %{conn: conn, session: session} do
      conn = delete conn, session_path(conn, :delete, session)
      assert redirected_to(conn) == session_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, session_path(conn, :show, session)
      end
    end
  end

  defp create_session(_) do
    session = fixture(:session)
    {:ok, session: session}
  end
end
