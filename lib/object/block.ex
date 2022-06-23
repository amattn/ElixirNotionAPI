defmodule Notion.Object.Block do
  @moduledoc """

  A block object represents content within Notion. Blocks can be text, lists, media, and more. A page is a type of block, too!

  https://developers.notion.com/reference/block

  """

  alias Notion.Object

  #  ######                                 #######
  #  #     # #       ####   ####  #    #       #    #   # #####  ######  ####
  #  #     # #      #    # #    # #   #        #     # #  #    # #      #
  #  ######  #      #    # #      ####         #      #   #    # #####   ####
  #  #     # #      #    # #      #  #         #      #   #####  #           #
  #  #     # #      #    # #    # #   #        #      #   #      #      #    #
  #  ######  ######  ####   ####  #    #       #      #   #      ######  ####
  #

  # Paragraph blocks
  # Heading one blocks
  # Heading two blocks
  # Heading three blocks
  # Callout blocks
  # Quote blocks
  # Bulleted list item blocks
  # Numbered list item blocks
  # To do blocks
  # Toggle blocks
  # Code blocks
  # Child page blocks
  # Child database blocks
  # Embed blocks
  # Image blocks
  # Video blocks
  # File blocks
  # PDF blocks
  # Bookmark blocks
  # Equation blocks
  # Divider blocks
  # Table of contents blocks
  # Breadcrumb blocks
  # Column List and Column Blocks
  # Link Preview blocks
  # Template blocks
  # Link to page blocks
  # Synced Block blocks
  # Table blocks
  # Table row blocks

  # Some blocks have more content nested inside them. Some examples are indented paragraphs, lists,
  # and toggles. The nested content is called children, and children are blocks, too!

  # Block types which support children are "paragraph", "bulleted_list_item", "numbered_list_item", "toggle",
  # "to_do", "quote", "callout", "synced_block", "template", "column", "child_page", "child_database", and "table".

  @doc """

  creates a heading 1 block with a singular rich text object

  https://developers.notion.com/reference/rich-text

  """
  def paragraph_block(content, children \\ [], color \\ "default")

  def paragraph_block(content, children, color)
      when is_bitstring(content) and is_list(children) and is_bitstring(color) do
    %{
      type: "paragraph",
      paragraph: %{
        rich_text: [Object.plain_text(content)],
        color: color,
        children: children
      }
    }
  end

  def paragraph_block(content_list, children, color)
      when is_list(content_list) and is_list(children) and is_bitstring(color) do
    %{
      type: "paragraph",
      paragraph: %{
        rich_text: content_list,
        color: color,
        children: children
      }
    }
  end

  @doc """
  This is not an official block, rather a paragraph block that holds a single URL
  """
  def url_block(url, content, color \\ "default")
      when is_bitstring(content) and is_bitstring(url) and is_bitstring(color) do
    %{
      type: "paragraph",
      paragraph: %{
        rich_text: [
          Object.url(url, content, color)
        ],
        color: color
      }
    }
  end

  @doc """
  creates a heading 1 block with a singular rich text object
  """
  def heading_1_block(content, color \\ "default")
      when is_bitstring(content) and is_bitstring(color) do
    heading_block("heading_1", content, color)
  end

  @doc """
  creates a heading 2 block with a singular rich text object
  """
  def heading_2_block(content, color \\ "default")
      when is_bitstring(content) and is_bitstring(color) do
    heading_block("heading_2", content, color)
  end

  @doc """
  creates a heading 3 block with a singular rich text object
  """
  def heading_3_block(content, color \\ "default")
      when is_bitstring(content) and is_bitstring(color) do
    heading_block("heading_3", content, color)
  end

  defp heading_block(type, content, color)
       when is_bitstring(type) and is_bitstring(content) and is_bitstring(color) do
    %{
      String.to_atom(type) => %{
        rich_text: [
          Object.plain_text(content)
        ],
        color: color
      },
      object: "block",
      type: type
    }
  end

  @doc """
  returns a divider block

    %{type: "divider", divider: %{}}

  """
  def divider_block() do
    %{type: "divider", divider: %{}}
  end
end
