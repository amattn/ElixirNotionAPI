defmodule Notion.Object.Parent do
  @moduledoc """

  https://developers.notion.com/reference/database#page-parent

  https://developers.notion.com/reference/database#workspace-parent

  """

  @doc """

  """
  def page_parent(page_id) do
    %{
      "type" => "page_id",
      "page_id" => page_id
    }
  end

  @doc """

  """
  def workspace_parent() do
    %{
      "type" => "workspace",
      "workspace" => true
    }
  end
end
