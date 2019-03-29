defmodule GuideExDoc.MixProject do
  use Mix.Project

  @analytics_id "UA-120089337-2"

  def project do
    [
      app: :membrane_framework_guide,
      name: "Membrane Guide",
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
      ],
      before_closing_body_tag: &analytics/1,
      before_closing_head_tag: &logo_fix/1
    ]
  end

  defp analytics(:epub), do: ""

  defp analytics(:html) do
    """
    <!-- Google Analytics -->
    <script>
    window.ga=window.ga||function(){(ga.q=ga.q||[]).push(arguments)};ga.l=+new Date;
    ga('create', '#{@analytics_id}', 'auto');
    ga('send', 'pageview');
    </script>
    <script async src='https://www.google-analytics.com/analytics.js'></script>
     <!-- End Google Analytics -->
    """
  end

  defp logo_fix(_) do
    """
    <style type="text/css">
    .sidebar a.sidebar-projectLink {
      text-align: center;
    }
    .sidebar div.sidebar-projectDetails:not(:last-child) {
      padding: 0 15px;
    }
    .sidebar img.sidebar-projectImage {
      margin: 10px;
      max-height: 128px;
      max-width: 128px;
    }
    </style>
    """
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19"},
      {:membrane_core, "~> 0.3.0"}
    ]
  end
end
