defmodule LunchboxBotTest do
  use ExUnit.Case
  doctest LunchboxBot

  test "select half ids" do
    ids = [1, 2, 3, 4, 5, 6]
    results = LunchboxBot.select_users(ids)
    assert length(results) == 3
  end
end
