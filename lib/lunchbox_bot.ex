defmodule LunchboxBot do
  @token Application.get_env(:lunchbox_bot, :slack_token)
  @channel Application.get_env(:lunchbox_bot, :slack_channel)
  @base_endpoint "https://slack.com/api/"
  @channel_info_path "/channels.info"
  @post_message_path "/chat.postMessage"
  @default_greeting """
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
  Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
  Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
  """

  def config do
    %{
      token: @token,
      channel: @channel
      greeting: Application.get_env(:lunchbox_bot, :greeting, @default_greeting)
    }
  end

  def run(%{token: token, channel: channel} = config) do
    case retrieve_users_in(token, channel) do
      {:ok, ids} ->
        ids
        |> Enum.shuffle
        |> create_couples
        |> post_to_slack(config)
      error ->
        error
    end
  end

  def post_to_slack(couples, config) do
    couples
    |> build_text(config)
    |> do_post_to_slack(config)
  end

  defp do_post_to_slack(text, %{token: token, channel: channel}) do
    HTTPoison.post("#{@base_endpoint}#{@post_message_path}", {:form, [token: token, channel: channel, text: text, link_names: true]})
  end

  def build_text(couples, config) do
    greeting = Map.fetch(config, :greeting)

    text =
      couples
      |> Enum.map(fn({a, b}) ->
        "<@#{a}> with <@#{b}>"
      end)
      |> Enum.join("\n")

    "#{greeting}\n #{text}"
  end

  def create_couples(user_ids) do
    {a, b} = Enum.split(user_ids, user_ids |> length |> Kernel./(2) |> Kernel.round)
    Enum.zip(a, b)
  end

  def retrieve_users_in(token, channel) do
    case HTTPoison.post("#{@base_endpoint}#{@channel_info_path}", {:form, [token: token, channel: channel]}) do
      {:ok, resp} ->
        ids =
          resp
          |> Map.get(:body, "")
          |> Poison.decode!
          |> Map.get("channel", %{})
          |> Map.get("members", %{})
        {:ok, ids}
      error ->
        error
    end
  end
end
