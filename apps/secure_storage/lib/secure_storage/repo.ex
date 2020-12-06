defmodule SecureStorage.Repo do
  use Ecto.Repo,
    otp_app: :secure_storage,
    adapter: Ecto.Adapters.Postgres
end
