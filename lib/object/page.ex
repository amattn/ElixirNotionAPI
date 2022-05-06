defmodule Notion.Object.Page do
  @moduledoc """

  The Page object contains the property values of a single Notion page.

  All pages have a parent. If the parent is a database, the property values conform to the schema laid out database's properties. Otherwise, the only property value is the title.

  Page content is available as blocks. The content can be read using retrieve block children and appended using append block children.

  https://developers.notion.com/reference/page
  """
end
