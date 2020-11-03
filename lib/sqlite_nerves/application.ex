defmodule SqliteNerves.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @otp_app Mix.Project.config[:app]

  def start(_type, _args) do
    :ok = setup_db!()
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SqliteNerves.Supervisor]

    children =
      [
        SqliteNerves.Repo,
        # Children for all targets
        # Starts a worker by calling: SqliteNerves.Worker.start_link(arg)
        # {SqliteNerves.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: SqliteNerves.Worker.start_link(arg)
      # {SqliteNerves.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: SqliteNerves.Worker.start_link(arg)
      # {SqliteNerves.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:sqlite_nerves, :target)
  end

  defp setup_db! do
    repos = Application.get_env(@otp_app, :ecto_repos)
    for repo <- repos do
      if Application.get_env(@otp_app, repo)[:adapter] == Sqlite.Ecto2 do
        Logger.info( "Setting up #{repo} repo" )
        IO.inspect( "Setting up #{repo} repo" )
        setup_repo!(repo)
        migrate_repo!(repo)
      end
    end
    :ok
  end

  defp setup_repo!(repo) do
    db_file = Application.get_env(@otp_app, repo)[:database]
    Logger.info( "DB Location #{db_file} repo" )
    IO.inspect( "DB Location #{db_file} repo" )
    unless File.exists?(db_file) do
      :ok = repo.__adapter__.storage_up(repo.config)
    end
  end

  defp migrate_repo!(repo) do
    opts = [all: true]
    {:ok, pid, apps} = Mix.Ecto.ensure_started(repo, opts)

    migrator = &Ecto.Migrator.run/4
    pool = repo.config[:pool]
    migrations_path = Path.join([:code.priv_dir(@otp_app) |> to_string, "repo", "migrations"])
    migrated =
      if function_exported?(pool, :unboxed_run, 2) do
        pool.unboxed_run(repo, fn -> migrator.(repo, migrations_path, :up, opts) end)
      else
        migrator.(repo, migrations_path, :up, opts)
      end

    pid && repo.stop(pid)
    Mix.Ecto.restart_apps_if_migrated(apps, migrated)
  end

end
