defmodule ExMon.Game.Actions.Attack do
  alias ExMon.Game
  alias ExMon.Game.Status

  @move_avg_power 18..25
  @move_rnd_power 10..25

  def attack_oponent(oponent, move) do
    damage = calculate_power(move)

    oponent
    |> Game.fetch_player()
    |> Map.get(:life)
    |> calculate_total_life(damage)
    |> update_oponent_life(oponent, damage)
  end

  defp calculate_power(:move_avg), do: Enum.random(@move_avg_power)
  defp calculate_power(:move_rnd), do: Enum.random(@move_rnd_power)

  defp calculate_total_life(life, damage) when life - damage < 0, do: 0
  defp calculate_total_life(life, damage), do: life - damage

  defp update_oponent_life(life, oponent, damage) do
    oponent
    |> Game.fetch_player()
    |> Map.put(:life, life)
    |> update_game(oponent, damage)
  end

  defp update_game(player, oponent, damage) do
    Game.info()
    |> Map.put(oponent, player)
    |> Game.update()

    Status.print_move_message(oponent, :attack, damage)
  end
end
