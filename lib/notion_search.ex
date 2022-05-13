defmodule Notion.Search do
  def search_pages(options \\ %{}) when is_map(options) do
    resp = Notion.V1.Search.post(options)

    case resp do
      %{"object" => "error"} ->
        {:error, resp}

      _ ->
        {:ok, resp}
    end
  end

  def search_pages(query, sort, filter, options \\ %{})
      when is_bitstring(query) and is_map(sort) and is_map(filter) and is_map(options) do
    options
    |> Enum.into(%{
      query: query,
      sort: sort,
      filter: filter
    })
    |> Map.reject(fn {_k, v} -> v == nil or v == "" or v == %{} end)

    search_pages(options)
  end

  def search_pages(query, sort, filter, start_cursor, page_size, options \\ %{})
      when is_bitstring(query) and is_map(sort) and is_map(filter) and
             is_bitstring(start_cursor) and is_integer(page_size) and is_map(options) do
    options
    |> Enum.into(%{
      query: query,
      sort: sort,
      filter: filter,
      start_cursor: start_cursor,
      page_size: page_size
    })
    |> Map.reject(fn {_k, v} -> v == nil or v == "" or v == %{} end)

    search_pages(options)
  end
end
