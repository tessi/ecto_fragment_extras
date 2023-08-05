defmodule ReadmeTest do
  use ExUnit.Case, async: true

  test "version in readme matches mix.exs" do
    readme_markdown = File.read!(Path.join(__DIR__, "../README.md"))
    mix_config = Mix.Project.config()
    version = mix_config[:version]
    assert version == "0.3.0"
    assert readme_markdown =~ ~s({:ecto_fragment_extras, "~> #{version}"})
  end
end
