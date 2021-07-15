defmodule Workflo.MixProject do
  use Mix.Project

  @spec application() :: keyword
  def application() do
    [
      extra_applications: [:logger]
    ]
  end

  @spec project() :: keyword
  def project() do
    [
      app: :workflo,
      deps: deps(),
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
    ]
  end

  ################################################################################
  # PRIVATE
  ################################################################################

  @spec deps() :: list(tuple)
  defp deps() do
    []
  end
end
