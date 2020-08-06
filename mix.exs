defmodule GuideExDoc.MixProject do
  use Mix.Project

  @analytics_id "UA-120089337-2"

  def project do
    [
      app: :membrane_framework_guide,
      name: "Membrane Guide",
      version: "0.5.0",
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
      javascript_config_path: "../docs_config.js",
      main: "introduction",
      extra_section: "Guide",
      extras:
        [
          "introduction.md",
          "packages.md",
          "coding_style_guide.md",
          # concepts
          "concepts/elements.md",
          "concepts/pipelines.md",
          "concepts/bins.md",
          # building apps
          "creating_app/pipeline.md",
          "creating_app/advanced.md",
          "creating_app/logger.md",
          # creating elements
          "creating_element/tutorial.md",
          "creating_element/testing.md",
          "creating_element/demands.md",
          "creating_element/natives.md",
          "creating_element/synchronization.md"
        ]
        |> Enum.map(&Path.join("guide", &1)),
      groups_for_extras: [
        Concepts: ~r"/concepts/",
        "Creating applications": ~r"/creating_app/",
        "Creating new elements": ~r"/creating_element/"
      ],
      before_closing_body_tag: &analytics/1,
      before_closing_head_tag: &head_hook/1
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

  defp head_hook(:epub), do: ""

  defp head_hook(:html) do
    """
    #{logo_fix()}
    #{favicon()}
    """
  end

  defp logo_fix() do
    """
    <style type="text/css">
    .sidebar div.sidebar-header {
      text-align: center;
      margin: 15px;
    }
    .sidebar img.sidebar-projectImage {
      margin: 10px;
      max-height: 128px;
      max-width: 128px;
    }
    </style>
    """
  end

  defp favicon() do
    """
    <link rel="icon" href="https://www.membraneframework.org/wp-content/uploads/2018/06/cropped-membrane_logo_favicon-1-32x32.png" sizes="32x32" />
    <link rel="icon" href="https://www.membraneframework.org/wp-content/uploads/2018/06/cropped-membrane_logo_favicon-1-192x192.png" sizes="192x192" />
    <link rel="apple-touch-icon-precomposed" href="https://www.membraneframework.org/wp-content/uploads/2018/06/cropped-membrane_logo_favicon-1-180x180.png" />
    <meta name="msapplication-TileImage" content="https://www.membraneframework.org/wp-content/uploads/2018/06/cropped-membrane_logo_favicon-1-270x270.png" />
    """
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21"},
      {:membrane_core, "~> 0.5.0"},
      {:membrane_element_tee, "~> 0.3.0"}
    ]
  end
end
