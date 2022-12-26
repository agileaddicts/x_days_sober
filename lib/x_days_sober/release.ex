defmodule XDaysSober.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """

  alias Ecto.Migrator

  @app :x_days_sober

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _returns, _apps} = Migrator.with_repo(repo, &Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()

    {:ok, _returns, _apps} = Migrator.with_repo(repo, &Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
