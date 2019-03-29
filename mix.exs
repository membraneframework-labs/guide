defmodule GuideExDoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :membrane_framework_guide,
      name: "Membrane<br/>Framework",
      version: "0.3.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      docs: docs(),
      deps: deps()
    ]
  end

  defp docs() do
    [
      api_reference: false,
      logo: "assets/logo.png",
      main: "readme",
      extra_section: "Guide",
      extras:
        [
          ".",
          "concepts",
          "creating_app",
          "creating_element"
        ]
        |> Enum.flat_map(&extras/1),
      groups_for_extras: [
        Concepts: extras("concepts"),
        "Building application": extras("creating_app"),
        "Creating new elements": extras("creating_element")
      ]
    ]
  end

  defp extras(group), do: Path.wildcard("#{group}/*.md") |> Enum.sort()

  defp deps do
    [
      {:ex_doc, "~> 0.19"},
      {:membrane_core, "~> 0.3.0"}
    ]
  end
end
