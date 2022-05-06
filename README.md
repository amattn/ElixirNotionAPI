![Build Status](https://github.com/amattn/ElixirNotionAPI/actions/workflows/elixir.yml/badge.svg)


# ElixirNotionAPI

This is a [Notion API][] client for Elixir.

It is derived from the work of Blake Williams and other contributors in the [Elixir-Slack][] repo.  This repo is not a fork, but a new library that borrows generously from their work.  

[Notion API]: https://developers.notion.com/docs/getting-started
[Elixir-Slack]: https://github.com/BlakeWilliams/Elixir-Slack

## Status

This package should be considered alpha, prototype software.

Not all endpoints are implemented. Endpoints that are implemented should work.  Check the unit tests for example usage.

## Installing

Add Notion API to your `mix.exs` `dependencies` function.

```elixir
def application do
  [extra_applications: [:logger]]
end

def deps do
  [{:notion_api, "~> 0.1"}]
end
```

## Notion API Usage

The complete Notion API is implemented by generating modules/functions from
the JSON documentation. You can view this project's [documentation] for more
details.

[documentation]: http://hexdocs.pm/notion_api/


### Internal integration token:

```elixir

config :notion_api, internal_integration_token: "secret_Sx4nkN4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx..."

```

### Public integration token:

API tokens are generated/fetched during the OAuth process.  store the tokens on a 
per workspace basis in your datastore.  Pass the appropriate token in 
`%{token: "VALUE"}` to any API call in `optional_params`. 


Quick example, getting the names of everyone on your team:

```elixir

resp = Notion.V1.Pages.PageId.get(page_id, %{token: "SOME_NOTION_TOKEN"})

```

### Web Client Configuration

A custom client callback module can be configured for cases in which you need extra control
over how calls to the web API are performed. This can be used to control timeouts, or to add additional
custom error handling as needed.

```elixir
config :notion_api, :web_http_client, YourApp.CustomClient
```

All Web API calls from documentation-generated modules/functions will call one of `get!/2`, `patch!/2`, 
`post!/2`, `delete!/2` with the generated url and body passed as arguments.

In the case where you only need to control the options passed to HTTPoison/hackney, the default client accepts
a keyword list as an additional configuration parameter. Note that this is ignored if configuring a custom client.

See [HTTPoison docs](https://hexdocs.pm/httpoison/HTTPoison.html#request/5) for a list of available options.

```elixir
config :notion_api, :web_http_client_opts, [timeout: 10_000, recv_timeout: 10_000]

# or set a proxy
config :notion_api, :web_http_client_opts, 
  [proxy: {"127.0.0.1", 9090}],
  hackney: [{:ssl_options, [{:cacertfile, "/path_to_cert/your_cert.pem"}]}]
```

