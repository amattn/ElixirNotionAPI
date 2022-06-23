defmodule Notion.Object do
  @moduledoc """
  Convenience and utliity functions for various object definitions used by the Notion API.

  Rich text, file and Emoji objects:

  https://developers.notion.com/reference/rich-text
  https://developers.notion.com/reference/file-object
  https://developers.notion.com/reference/emoji-object

  """

  @doc """
  simple text rich text object
  """
  def plain_text(content) when is_bitstring(content) do
    %{
      type: "text",
      text: %{
        content: content,
        link: nil
      }
    }
  end

  @doc """
  URL or link rich text object
  """
  def url(url_string) when is_bitstring(url_string) do
    url(url_string, url_string)
  end

  def url(url_string, content, color \\ "default")
      when is_bitstring(url_string) and is_bitstring(content) do
    %{
      type: "text",
      text: %{
        content: content,
        link: %{
          url: url_string
        }
      },
      annotations: %{
        color: color
      },
      plain_text: content,
      href: url_string
    }
  end

  @doc """
  Emoji objects contain emoji data for page icons.

  must be a single emoji
  """
  def emoji_object(emoji_character) when is_bitstring(emoji_character) do
    %{
      type: "emoji",
      emoji: emoji_character
    }
  end

  @doc """
  Sort object is exclusively used by the Search API endpoint

  direction must be one of "ascending" and "descending".


  https://developers.notion.com/reference/post-search

  """
  def sort(direction) when is_bitstring(direction) do
    %{
      direction: direction,
      timestamp: "last_edited_time"
    }
  end

  @doc """
  Sort ascending object to be used by the Search API endpoint

  https://developers.notion.com/reference/post-search

  """
  def sort_ascending(), do: sort("ascending")

  @doc """
  Sort descending object to be used by the Search API endpoint

  https://developers.notion.com/reference/post-search

  """
  def sort_descending(), do: sort("descending")

  @doc """
  filter object is used by the Search API endpoint to filter the
  results based on the provided criteria.

  page_or_database must be either "page" or "database"

  https://developers.notion.com/reference/post-search

  """
  def filter(page_or_database) do
    %{
      property: "object",
      value: page_or_database
    }
  end

  @doc """
  Filter by page object to be optionally used by the Search API endpoint

  https://developers.notion.com/reference/post-search

  """
  def filter_by_page(), do: filter("page")

  @doc """
  Filter by database object to be optionally used by the Search API endpoint

  https://developers.notion.com/reference/post-search

  """
  def filter_by_database(), do: filter("database")
end
