defmodule ChatterWeb.Auth do
    import Comeonin.Pbkdf2, only: [checkpw: 2,dummy_checkpw: 0]
    import Plug.Conn

    defp login(conn, user) do
        conn
        |> Chatter.Guardian.Plug.sign_in(user)
    end

    def login_with(conn, email, pass, opts) do
        repo = Keyword.fetch!(opts, :repo)
        user = repo.get_by(Chatter.User, email: email)

        cond do
            user && checkpw(pass, user.encrypt_pass) ->
                {:ok, login(conn, user)}
            user ->
                {:error, :unauthorized, conn}
            true ->
                dummy_checkpw()
                {:error, :not_found, conn}
        end
    end
end