defmodule Lunchbot.Slackbot do
  @post_message_path "chat.postMessage"
  @get_channel_list_path "conversations.list"

  def default_config(), do: Application.get_env(:lunchbot, :slackbot)

  def send_lunch_reminder(channelName, lunchURL, config \\ default_config()) do
    url = Keyword.get(config, :url, "") <> @post_message_path
    http_client = Keyword.get(config, :http_client)

    headers = [
      {"Accept", "application/json"},
      {"Authorization", "Bearer #{System.get_env("SLACK_BOT_TOKEN")}"},
      {"Content-Type", "application/json"}
    ]

    body = %{
      channel: get_channel_id(channelName),
      blocks: [
        %{
          type: "section",
          text: %{
            type: "mrkdwn",
            text: "*Reminder to submit lunch order before 1pm today*:alarm:"
          }
        },
        %{
          type: "actions",
          elements: [
            %{
              type: "button",
              text: %{
                type: "plain_text",
                text: "Lunch Link :sandwich:",
                emoji: true
              },
              value: "lunch_link",
              url: lunchURL,
              action_id: "messageLinkedClicked"
            }
          ]
        }
      ]
    }

    {status, json_body} = JSON.encode(body)

    http_client.post(url, json_body, headers, follow_redirect: true)

    status
  end

  def get_channel_id(channelName, config \\ default_config()) do
    url = Keyword.get(config, :url, "") <> @get_channel_list_path
    http_client = Keyword.get(config, :http_client)

    headers = [
      {"Accept", "application/json"},
      {"Authorization", "Bearer #{System.get_env("SLACK_BOT_TOKEN")}"},
      {"Content-Type", "application/json"}
    ]

    channelInfo =
      http_client.get!(url, headers, follow_redirect: true)
      |> Map.get(:body)
      |> Jason.decode!()
      |> Map.get("channels")
      |> Enum.find(fn x -> Map.get(x, "name") == channelName end)

    if channelInfo != nil do
      Map.get(channelInfo, "id")
    end
  end

  def if_noon_on_monday_thursday_send_slack_message() do
    alias Lunchbot.Repo

    Ecto.Adapters.SQL.query!(
      Repo,
      "SELECT
        name,
        slack_channel_name,
        timezone
      FROM
        offices
      WHERE
        Extract(hour FROM CURRENT_TIMESTAMP AT TIME zone timezone) = 12
        AND
        Extract(day FROM CURRENT_TIMESTAMP AT TIME zone timezone) in (1,4);",
      []
    ).rows
    |> Enum.each(fn office ->
      send_lunch_reminder(Enum.fetch(office, 1), "https://lunchbot.withmojo.com/")
    end)
  end
end
