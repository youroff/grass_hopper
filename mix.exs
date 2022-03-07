defmodule GrassHopper.MixProject do
  use Mix.Project

  def project do
    [
      app: :grass_hopper,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def description, do: """
    GrassHopper is a tiny abstraction over GenServer, that helps building dynamically scheduled recursive processes.
    It allows to efficiently jump along timestamps and perform user defined actions
  """

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:mock, "~> 0.3", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package, do: [
    files: ["lib", "mix.exs", "README*", "LICENSE*"],
    maintainers: ["Ivan Yurov"],
    licenses: ["MIT"],
    links: %{"GitHub" => "https://github.com/youroff/grass_hopper"}
   ]
end
