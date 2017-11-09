defmodule Chatter.Token do
    use ChatterWeb, :controller

    def unaunthenticated(conn, _params) do
        conn
        |> put_flash(:error, "You must be signed in!")
        |> redirect(to: session_path(conn, :new))
    end

    def unauthorized(conn, _params) do
        conn
        |> put_flash(:error, "You must be signed in!")
        |> redirect(to: session_path(conn, :new))
    end
end