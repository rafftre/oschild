defmodule Child.MixProject do
  use Mix.Project

  def project do
    [
      app: :child,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # extra_applications: [:logger]
      # fix problems in Sonoma with Erlang/OTP 26
      extra_applications: [:logger, :observer, :runtime_tools, :wx]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false}
    ]
  end
end
