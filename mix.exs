defmodule Notion.Mixfile do
  use Mix.Project

  def project do
    [
      app: :notion_api,
      version: "0.3.4",
      elixir: ">= 1.10.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "ElixirNotionAPI",
      deps: deps(),
      docs: docs(),
      package: package(),
      name: "ElixirNotionAPI",
      source_url: "https://github.com/amattn/ElixirNotionAPI",
      description: "An Elixir Notion API client"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.3"},
      {:ex_doc, "~> 0.28", only: :dev},
      {:credo, "~> 1.6", only: [:dev, :test]},
      {:plug_cowboy, "~> 2.5"}
    ]
  end

  def docs do
    [
      {:main, Notion},
      {:assets, "guides/assets"},
      {:extra_section, "GUIDES"},
      {:extras, ["guides/token_generation_instructions.md"]}
    ]
  end

  defp package do
    %{
      name: "notion_api",
      maintainers: ["amattn"],
      licenses: ["MIT"],
      links: %{
        Github: "https://github.com/amattn/ElixirNotionAPI",
        Documentation: "https://hexdocs.pm/notion_api/"
      }
    }
  end
end
