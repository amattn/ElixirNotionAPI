defmodule Notion.Client do
  @moduledoc """
  Defines a custom client for making calls to Notion API.
  """

  @type url :: String.t()
  @type headers :: List.t()
  @type form_body :: {:form, Keyword.t()}
  @type multipart_form_body :: {:multipart, nonempty_list(tuple())}
  @type body :: form_body() | multipart_form_body()

  @doc """
  Return value is passed directly to caller of generated Web API
  module/functions. Can be any term.
  """
  @callback delete!(url :: url, headers :: headers) :: term()
  @callback get!(url :: url, headers :: headers) :: term()
  @callback patch!(url :: url, headers :: headers, body :: body) :: term()
  @callback post!(url :: url, headers :: headers, body :: body) :: term()
end
