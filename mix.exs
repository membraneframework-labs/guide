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
      main: "introduction",
      extra_section: "Guide",
      extras:
        [
          "introduction.md",
          # concepts
          "concepts/elements.md",
          "concepts/pipelines.md",
          # building apps
          "creating_app/pipeline.md",
          "creating_app/logger.md",
          # creating elements
          "creating_element/tutorial.md",
          "creating_element/testing.md",
          "creating_element/demands.md",
          "creating_element/natives.md"
        ]
        |> Enum.map(&Path.join("guide", &1)),
      groups_for_extras: [
        Concepts: ~r"/concepts/",
        "Building application": ~r"/creating_app/",
        "Creating new elements": ~r"/creating_element/"
      ]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19"},
      {:membrane_core, "~> 0.3.0"}
    ]
  end
end
