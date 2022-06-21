defmodule Notion do
  @moduledoc false

  def get_documentation do
    File.ls!("#{__DIR__}/docs")
    |> format_documentation
  end

  defp format_documentation(files) do
    Enum.reduce(files, %{}, fn file, module_names ->
      json =
        File.read!("#{__DIR__}/docs/#{file}")
        |> Jason.decode!()

      doc = Notion.Documentation.new(json, file)

      module_names
      |> Map.put_new(doc.module, [])
      |> update_in([doc.module], &(&1 ++ [doc]))
    end)
  end
end

alias Notion.Documentation
require Logger

Enum.each(Notion.get_documentation(), fn {module_name, functions} ->
  module =
    module_name
    |> String.split(".")
    |> Enum.map(&Macro.camelize/1)
    |> Enum.reduce(Notion, &Module.concat(&2, &1))

  Logger.warning("module: #{inspect(module)}", "🐛": :" 355217549")

  defmodule module do
    Enum.each(functions, fn doc ->
      function_name = doc.function

      path_params_with_values = Documentation.path_params_with_values(doc)
      function_arguments = Documentation.function_arguments(doc)
      required_params_with_values = Documentation.required_params_with_values(doc)

      @doc """
      #{Documentation.to_doc_string(doc)}
      """
      def unquote(function_name)(unquote_splicing(function_arguments), optional_params \\ %{})
          when is_map(optional_params) do
        required_params_map = Enum.into(unquote(required_params_with_values), %{})

        # Logger.warning("required_params_map: #{inspect(required_params_map)}", "🐛": :" 1231437220")

        url = Application.get_env(:notion_api, :base_url, "https://api.notion.com")

        # path_params are substituted into the url in the path_parameter_substition funtion
        # the remaining required and optional params are mereged here and eventually converted to JSON in the body_params_processing function

        param_map =
          optional_params
          # strip out empty optional params.  importantly, retain empty required params
          |> Map.reject(fn {_, v} -> v == nil end)
          |> Map.merge(required_params_map)
          # token is special case we inject into header
          |> Map.reject(fn {k, _} -> k == :token end)
          |> Enum.map(fn {key, val} ->
            # Logger.warning("param key: #{inspect(key)}", "🐛": :" 801437221")
            # Logger.warning("param val: #{inspect(val)}", "🐛": :" 801437222")

            convert_param_value(key, val)
          end)
          # convert into map
          |> Enum.into(%{})

        # Logger.warning("param_map: #{inspect(param_map)}", "🐛": :" 801437223")

        # Logger.warning(
        #   "unq path_params_with_values: #{inspect(unquote(path_params_with_values))}",
        #   "🐛": :" 801437224"
        # )

        # Logger.warning(
        #   "argument_value_keyword_list: #{inspect(unquote(argument_value_keyword_list))}",
        #   "🐛": :" 801437225"
        # )

        url_path =
          path_parameter_substition(unquote(doc.endpoint), unquote(path_params_with_values))

        headers = [
          {"Content-Type", "application/json; charset=utf-8"},
          {"Authorization", "Bearer #{get_token(optional_params)}"},
          {"Notion-Version", "2022-02-22"}
        ]

        case unquote(doc.function) do
          :get ->
            get!(
              "#{url}/#{url_path}",
              headers
            )

          :patch ->
            patch!(
              "#{url}/#{url_path}",
              headers,
              body_params_processing(
                unquote(function_name),
                param_map,
                unquote(function_arguments)
              )
            )

          :post ->
            post!(
              "#{url}/#{url_path}",
              headers,
              body_params_processing(
                unquote(function_name),
                param_map,
                unquote(function_arguments)
              )
            )

          :delete ->
            Logger.error("TODO 3577386783", "🐛": :" 3577386783")

          _ ->
            Logger.error("Should never get here", "🐛": :" 3577386789")
        end
      end
    end)

    defp get!(url, headers) do
      # Logger.warning("get: #{inspect(url)}", "🐛": :" 12345280240")
      Application.get_env(:notion_api, :web_http_client, Notion.DefaultClient).get!(url, headers)
    end

    defp post!(url, headers, body) do
      # Logger.warning("post: #{inspect(url)}", "🐛": :" 12345280440")
      # Logger.warning("post: #{inspect(headers)}", "🐛": :" 12345280441")
      # Logger.warning("post: #{inspect(body)}", "🐛": :" 12345280442")

      Application.get_env(:notion_api, :web_http_client, Notion.DefaultClient).post!(
        url,
        headers,
        body
      )
    end

    defp patch!(url, headers, body) do
      # Logger.warning("patch: #{inspect(url)}", "🐛": :" 1234215315")
      # Logger.warning("patch: #{inspect(headers)}", "🐛": :" 1234215316")
      # Logger.warning("patch: #{inspect(body)}", "🐛": :" 1234215317")

      Application.get_env(:notion_api, :web_http_client, Notion.DefaultClient).patch!(
        url,
        headers,
        body
      )
    end

    defp get_token(%{token: token}), do: token
    defp get_token(_), do: Application.get_env(:notion_api, :internal_integration_token)

    # if we have any non-Jason supported types, we can convert them here
    defp convert_param_value(key, value) do
      {key, value}
    end

    defp path_parameter_substition(endpoint, path_params_with_values) do
      # Logger.warning("path_parameter_substition endpoint: #{inspect(endpoint)}",
      #   "🐛": :" 1339620391"
      # )

      # Logger.warning(
      #   "path_parameter_substition path_params_with_values: #{inspect(path_params_with_values)}",
      #   "🐛": :" 1339620392"
      # )

      Enum.reduce(path_params_with_values, endpoint, fn {key, val}, acc ->
        # Logger.warning("{key, val}: #{inspect({key, val})}", "🐛": :" 794991620")
        # Logger.warning("acc: #{inspect(acc)}", "🐛": :" 794991620")

        path_sub_key = to_string(key)
        String.replace(acc, path_sub_key, val)
      end)

      # |> tap(fn x ->
      #   Logger.warning("path_parameter_substition return value: #{inspect(x)}",
      #     "🐛": :" 3580239419"
      #   )
      # end)
    end

    # notion API seems to only use JASON for reqest body and response body
    defp body_params_processing(_, params, _) do
      Jason.encode!(params)
    end
  end
end)
