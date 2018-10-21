defmodule BoltSips.Mixfile do
  use Mix.Project

  @version "1.0.0-rc2"

  def project do
    [
      app: :bolt_sips,
      version: @version,
      elixir: "~> 1.6",
      deps: deps(),
      package: package(),
      description: "Neo4j driver for Elixir, using the fast Bolt protocol",
      name: "Bolt.Sips",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      docs: [
        extras: ["README.md", "CHANGELOG.md"],
        source_ref: "v#{@version}",
        source_url: "https://github.com/florinpatrascu/bolt_sips"
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger,
        :db_connection,
        :retry,
        :boltex,
        :fuzzyurl
      ]
    ]
  end

  defp package do
    %{
      licenses: ["Apache 2.0"],
      maintainers: ["Florin T.PATRASCU", "Dmitriy Nesteryuk"],
      links: %{"Github" => "https://github.com/florinpatrascu/bolt_sips"}
    }
  end

  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:db_connection, "~> 2.0.0-rc.0"},
      {:fuzzyurl, "~> 1.0"},
      {:retry, "0.9.1"},
      # {:boltex, path: "../boltex/"},
      {:boltex, "0.4.1"},
      {:ex_doc, "~> 0.16.4", only: [:dev]},
      {:mix_test_watch, "~> 0.9", only: [:dev, :test]},
      {:benchee, "~> 0.13", only: :dev},
      {:credo, "~> 0.4", only: [:dev, :test]}
    ]
  end
end
