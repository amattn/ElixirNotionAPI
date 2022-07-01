defmodule Notion.Databases do
  def create_database(page_id, properties \\ %{}, options \\ %{})
      when is_bitstring(page_id) and is_map(properties) and is_map(options) do
    resp =
      Notion.V1.Databases.post(%{"type" => "page_id", "page_id" => page_id}, properties, options)

    case resp do
      %{"object" => "error"} ->
        {:error, resp}

      _ ->
        {:ok, resp}
    end
  end

  def query_database(database_id, filter, options \\ %{}) when is_bitstring(database_id) do
    all_options = Enum.into(%{filter: filter}, options)
    Notion.V1.Databases.DatabaseId.Query.post(database_id, all_options)
  end
end
