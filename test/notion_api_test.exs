defmodule NotionApiTest do
  use ExUnit.Case

  require Logger

  describe "page test" do
    test "simple get test" do
      # This test ruquires you to setup a test workspace in notion and configure values in config/test.secret.exs
      # 1. setup a test workspace
      # 2. create an internal integration
      # 3. create a test page
      # 4. share that page with the integration you created
      # 5. configure token and page_id values in config/test.secret.exs

      options = %{
        token: Application.fetch_env!(:notion_api, :test_workspace_integration_token)
      }

      page_id = Application.fetch_env!(:notion_api, :test_workspace_retrieve_page_id)

      # resp = Notion.V1.Pages.page_id("123", options)
      resp = Notion.V1.Pages.PageId.get(page_id, options)

      assert resp["id"] == page_id
      assert resp["object"] == "page"
      assert String.starts_with?(resp["url"], "https://www.notion.so/")

      # assert resp == %{"blahblah" => "FORCE_ERROR"}
    end

    test "create and delete page test" do
      # This test ruquires you to setup a test workspace in notion and configure values in config/test.secret.exs
      # 1. setup a test workspace
      # 2. create an internal integration
      # 3. create a test page
      # 4. share that page with the integration you created
      # 5. configure token and page_id values in config/test.secret.exs

      shared_options = %{
        token: Application.fetch_env!(:notion_api, :test_workspace_integration_token),
        icon: %{emoji: "✂️"}
      }

      create_options = %{
        icon: %{emoji: "✂️"},
        children: [
          %{
            object: "block",
            type: "heading_2",
            heading_2: %{
              rich_text: [%{type: "text", text: %{content: "Lacinato kale"}}]
            }
          },
          %{
            object: "block",
            type: "paragraph",
            paragraph: %{
              rich_text: [
                %{
                  type: "text",
                  text: %{
                    content:
                      "Lacinato kale is a variety of kale with a long tradition in Italian cuisine, especially that of Tuscany. It is also known as Tuscan kale, Italian kale, dinosaur kale, kale, flat back kale, palm tree kale, or black Tuscan palm.",
                    link: %{url: "https://en.wikipedia.org/wiki/Lacinato_kale"}
                  }
                }
              ]
            }
          }
        ]
      }

      options =
        shared_options
        |> Enum.into(create_options)

      page_id = Application.fetch_env!(:notion_api, :test_workspace_retrieve_page_id)

      properties = %{
        "title" => [
          %{
            type: "text",
            text: %{
              content: "Unit Test create and delete page test #{DateTime.utc_now()} 3473592541 "
            }
          }
        ]
      }

      # resp = Notion.V1.Pages.page_id("123", options)
      resp = Notion.V1.Pages.post(%{"page_id" => page_id}, properties, options)
      # assert resp == %{"blahblah" => "FORCE_ERROR"}
      refute resp["object"] == "error"

      refute resp["id"] == page_id
      assert resp["object"] == "page"
      assert resp["archived"] == false
      assert String.starts_with?(resp["url"], "https://www.notion.so/")

      new_page_id = resp["id"]
      # new_page_id = "a1bde3216fa944b7958ca3ebc8294c8b"

      options =
        shared_options
        |> Enum.into(%{"archived" => true})

      resp = Notion.V1.Pages.PageId.patch(new_page_id, options)
      # assert resp == %{"blahblah" => "FORCE_ERROR"}
      refute resp["object"] == "error"
      assert resp["archived"] == true
    end
  end

  describe "error test" do
    test "simple error test" do
      options = %{token: "NOT_A_REAL_TOKEN"}

      page_id = "c416a76a-4444-4444-4444-111111111111"

      # resp = Notion.V1.Pages.page_id("123", options)
      resp = Notion.V1.Pages.PageId.get(page_id, options)

      assert(
        resp == %{
          "code" => "unauthorized",
          "message" => "API token is invalid.",
          "object" => "error",
          "status" => 401
        }
      )
    end
  end

  describe "user test" do
    test "simple get list test" do
      options = %{
        token: Application.fetch_env!(:notion_api, :test_workspace_integration_token)
      }

      resp = Notion.V1.Users.get(options)

      refute resp["object"] == "error"
      assert resp["object"] == "list"
      # assert resp["has_more"] == false
      # Logger.warning("MESSAGE: #{inspect(resp, pretty: true, width: 4)}", "🐛": :" 1932266915")
    end
  end
end
