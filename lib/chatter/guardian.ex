defmodule Chatter.Guardian do
    use Guardian, otp_app: :chatter
    alias Chatter.Repo
    alias Chatter.User
  
    def subject_for_token(resource = %User{}, _claims) do
      {:ok, to_string(resource.id)}
    end
  
    def subject_for_token(_, _) do
      {:error, "Unknown resource type"}
    end
  
    def resource_from_claims(claims) do
      {:ok, Repo.get(User, claims["sub"])}
    end
    def resource_from_claims(_claims) do
      {:error, "Unknown resource type"}
    end
  end