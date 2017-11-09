defmodule ChatterWeb.SessionController do
  use ChatterWeb, :controller
  import ChatterWeb.Auth
  alias Chatter.Repo
  alias Chatter.Guardian

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => user, "password" => password }}) do
    case login_with(conn, user, password, repo: Repo) do
      {:ok, conn} ->
        logger_user = Guardian.Plug.current_resource(conn)

        conn
        |>  put_flash(:info, "logged in!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "wrong username/password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: "/")
  end

  def auth_error(conn, {type, reason}, _opts) do
    IO.inspect type

    case type do
      :already_authenticated ->
        conn
        |> redirect(to: user_path(conn,:index))
        |> halt()
      :unauthenticated ->
        conn
        |> redirect(to: session_path(conn, :new))
        |> halt()
      _ -> 
        body = Poison.encode!(%{message: to_string(type)})
        send_resp(conn, 401, body)
    end
  end
end
