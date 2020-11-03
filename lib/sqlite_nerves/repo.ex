defmodule SqliteNerves.Repo do
  use Ecto.Repo, otp_app: :sqlite_nerves, adapter: Sqlite.Ecto2
end
