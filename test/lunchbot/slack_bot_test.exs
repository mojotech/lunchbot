ExUnit.start()

defmodule Lunchbot.SlackBotTest do
  use ExUnit.Case
  import Mox

  alias Lunchbot.Slackbot
  @http_client Lunchbot.HTTPClientMock
  @test_config http_client: @http_client, url: "https://slack.com/api/"
  @json_resp %HTTPoison.Response{
    body: File.read!("test/lunchbot/slackbot_mock_body.json"),
    status_code: 200
  }

  describe "get_channel_id/1" do
    test "test if channel id is correct" do
      expect(@http_client, :get!, fn "https://slack.com/api/conversations.list", _, _ ->
        @json_resp
      end)

      assert Slackbot.get_channel_id("testChannel", @test_config) == "DKHKK80JC"
    end

    test "A non existent channel results in nil" do
      expect(@http_client, :get!, fn "https://slack.com/api/conversations.list", _, _ ->
        @json_resp
      end)

      assert Slackbot.get_channel_id("NotRealSlackChannel", @test_config) == nil
    end
  end
end
