defmodule Notion.Documentation do
  require Logger
  @moduledoc false

  defstruct [
    :endpoint,
    :module,
    :function,
    :desc,
    :path_params,
    :required_params,
    :optional_params,
    :errors,
    :raw
  ]

  def new(documentation, file_name) do
    docfile = String.replace(file_name, ".json", "")

    {module_name, function_name, endpoint} = parse_docfile(docfile)

    Logger.warning("module_name: #{inspect(module_name)}", "🐛": :" 1263516791")
    Logger.warning("function_name: #{inspect(function_name)}", "🐛": :" 1263516792")
    Logger.warning("endpoint: #{inspect(endpoint)}", "🐛": :" 1263516794")

    %__MODULE__{
      module: module_name,
      endpoint: endpoint,
      function: function_name |> Macro.underscore() |> String.to_atom(),
      desc: documentation["desc"],
      path_params: get_path_params(documentation),
      required_params: get_required_params(documentation),
      optional_params: get_optional_params(documentation),
      errors: documentation["errors"],
      raw: documentation
    }
  end

  def path_params(documentation) do
    Logger.warning("documentation.path_params: #{inspect(documentation.path_params)}",
      "🐛": :" 2213016336"
    )

    documentation.path_params
    |> Enum.map(&Macro.var(&1, nil))
    |> tap(fn x ->
      Logger.warning("path_params: #{inspect(x)}", "🐛": :" 3580239419")
    end)
  end

  def path_params_with_values(documentation) do
    documentation
    |> path_params()
    |> Enum.reduce([], fn var = {arg, _, _}, acc ->
      [{arg, var} | acc]
    end)
    |> tap(fn x ->
      Logger.warning("path_params_with_values: #{inspect(x)}", "🐛": :" 3580239419")
    end)
  end

  def required_params(documentation) do
    documentation.required_params
    |> Enum.map(&Macro.var(&1, nil))
    |> tap(fn x ->
      Logger.warning("required_params: #{inspect(x)}", "🐛": :" 3580239419")
    end)
  end

  def required_params_with_values(documentation) do
    documentation
    |> required_params()
    |> Enum.reduce([], fn var = {arg, _, _}, acc ->
      [{arg, var} | acc]
    end)
    |> tap(fn x ->
      Logger.warning("required_params_with_values: #{inspect(x)}", "🐛": :" 3580239419")
    end)
  end

  @doc """
  path params and required params
  """
  def function_arguments(documentation) do
    Logger.warning(
      "3159991338 documentation.required_params: #{inspect(documentation.required_params)}",
      "🐛": :" 3159991338"
    )

    Logger.warning(
      "3159991338 documentation.path_params: #{inspect(documentation.path_params)}",
      "🐛": :" 3159991338"
    )

    (documentation.path_params ++ documentation.required_params)
    |> Enum.map(&Macro.var(&1, nil))
  end

  def arguments_with_values(documentation) do
    documentation
    |> function_arguments()
    |> Enum.reduce([], fn var = {arg, _, _}, acc ->
      [{arg, var} | acc]
    end)
    |> tap(fn x ->
      Logger.warning("arguments_with_values: #{inspect(x)}", "🐛": :" 3580239419")
    end)
  end

  def to_doc_string(documentation) do
    Enum.join(
      [
        documentation.desc,
        path_params_docs(documentation),
        required_params_docs(documentation),
        optional_params_docs(documentation),
        errors_docs(documentation)
      ],
      "\n"
    )
  end

  defp path_params_docs(%__MODULE__{path_params: []}), do: ""

  defp path_params_docs(documentation) do
    get_param_docs_for(documentation, :path_params, "Path Params")
  end

  defp required_params_docs(%__MODULE__{required_params: []}), do: ""

  defp required_params_docs(documentation) do
    get_param_docs_for(documentation, :required_params, "Required Params")
  end

  defp optional_params_docs(%__MODULE__{optional_params: []}), do: ""

  defp optional_params_docs(documentation) do
    get_param_docs_for(documentation, :optional_params, "Optional Params")
  end

  defp get_param_docs_for(documentation, field, title) do
    Map.get(documentation, field)
    |> Enum.reduce("\n#{title}\n", fn param, doc ->
      meta = get_in(documentation.raw, ["args", to_string(param)])
      doc <> "* `#{param}` - #{meta["desc"]} #{example(meta)}\n"
    end)
  end

  def example(%{"example" => example}) do
    "ex: `#{example}`"
  end

  def example(_meta), do: ""

  defp errors_docs(%__MODULE__{errors: nil}), do: ""

  defp errors_docs(%__MODULE__{errors: errors}) do
    errors
    |> Enum.reduce("\nErrors the API can return:\n", fn {error, desc}, doc ->
      doc <> "* `#{error}` - #{desc}\n"
    end)
  end

  defp get_path_params(json) do
    %{"args" => args} = json
    Logger.warning("args: #{inspect(args)}", "🐛": :" 1231791061")

    args
    |> Enum.filter(fn {_, meta} ->
      meta["path_params"]
    end)
    |> Enum.map(fn {name, _meta} ->
      name |> String.to_atom()
    end)
    |> tap(fn x ->
      Logger.warning("path_params: #{inspect(x)}", "🐛": :" 3580239419")
    end)
  end

  defp get_required_params(json), do: get_params_with_required(json, true)
  defp get_optional_params(json), do: get_params_with_required(json, false)

  defp get_params_with_required(%{"args" => args}, required) do
    args
    |> Enum.filter(fn {_, meta} ->
      if required do
        meta["required"]
      else
        !meta["required"]
      end
    end)
    |> Enum.map(fn {name, _meta} ->
      name |> String.to_atom()
    end)
  end

  defp get_params_with_required(_json, _required) do
    []
  end

  @spec parse_docfile(String.t()) :: {String.t(), String.t(), String.t()}
  defp parse_docfile(docfile) do
    {module_name, function_name} =
      docfile
      |> String.graphemes()
      |> Enum.reverse()
      |> Enum.find_index(&(&1 == "."))
      |> (&String.split_at(docfile, -&1)).()

    clean_module_name = String.replace_suffix(module_name, ".", "")
    endpoint = String.replace(module_name, ".", "/")

    Logger.warning("parse_docfile docfile: #{inspect(docfile)}", "🐛": :" 3716542473")

    Logger.warning("parse_docfile clean_module_name: #{inspect(clean_module_name)}",
      "🐛": :" 3716542473"
    )

    Logger.warning("parse_docfile function_name: #{inspect(function_name)}", "🐛": :" 3716542473")
    Logger.warning("parse_docfile endpoint: #{inspect(endpoint)}", "🐛": :" 3716542473")

    {clean_module_name, function_name, endpoint}
  end
end
