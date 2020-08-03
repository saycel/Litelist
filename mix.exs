defmodule Litelist.Mixfile do
  use Mix.Project

  def project do
    [
      app: :litelist,
      version: "0.1.0",
      elixir: "~> 1.10.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Litelist.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.1.0"},
      {:ecto_sql, "~> 3.4.5"},
      {:postgrex, "~> 0.15.5"},
      {:phoenix_html, "~> 2.14.2"},
      {:phoenix_live_reload, "~> 1.2.4", only: :dev},
      {:gettext, "~> 0.18.1"},
      {:plug_cowboy, "~> 2.3.0"},
      {:plug, "~> 1.10.3"},
      {:guardian, "~> 2.1.1"},
      {:argon2_elixir, "~> 2.0"},
      {:pbkdf2_elixir, "~> 1.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:ex_machina, "~> 2.4.0"},
      {:faker_elixir_octopus, "~> 1.0.2"},
      {:excoveralls, "~> 0.13.1", only: :test},
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22.2"},
      {:quantum, "~> 2.3.3"},
      {:timex, "~> 3.6.2"},
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.3"},
      {:uuid, "~> 1.1.8"},
      {:phoenix_html_simplified_helpers, "~> 2.1.0"},
      {:jason, "~> 1.2.1"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
