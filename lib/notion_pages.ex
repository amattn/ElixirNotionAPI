defmodule Notion.Pages do
  def create_page(page_id, properties \\ %{}, options \\ %{})
      when is_map(properties) and is_map(options) do
    resp = Notion.V1.Pages.post(%{"page_id" => page_id}, properties, options)

    case resp do
      %{"object" => "error"} ->
        {:error, resp}

      _ ->
        {:ok, resp}
    end
  end
end
