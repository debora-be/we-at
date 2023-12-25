defmodule WeAt.MixProject do
  use Mix.Project

  def project do
    [
      app: :we_at,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: WeAt.Weather.IO]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
