defmodule Notion.DefaultClient do
  @moduledoc """
  Default http client used for all requests to Notion API.

  Parsed body data is returned unwrapped to the caller.

  Additional error handling or response wrapping can be controlled as needed
  by configuring a custom client module.

  ```
  config :notion_api, :web_http_client, YourApp.CustomClient
  ```
  """

  @behaviour Notion.Client

  @impl true
  def delete!(url, headers) do
    url
    |> HTTPoison.delete!(headers, opts())
    |> Map.fetch!(:body)
    |> Jason.decode!()
  end

  @impl true
  def get!(url, headers) do
    url
    |> HTTPoison.get!(headers, opts())
    |> Map.fetch!(:body)
    |> Jason.decode!()
  end

  @impl true
  def patch!(url, headers, body) do
    url
    |> HTTPoison.patch!(body, headers, opts())
    |> Map.fetch!(:body)
    |> Jason.decode!()
  end

  @impl true
  def post!(url, headers, body) do
    url
    |> HTTPoison.post!(body, headers, opts())
    |> Map.fetch!(:body)
    |> Jason.decode!()
  end

  defp opts do
    Application.get_env(:notion_api, :web_http_client_opts, [])
  end
end
