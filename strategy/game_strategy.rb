class StrategyException < RuntimeError

end

# All strategies will give the current state of the game as return value to `next_move` and `first_move`
class GameStrategy
  def next_move(position_in_board)
    raise NotImplementedError,
          'All strategies of game should define the next move, and returns a game'
  end

  def switch_player(current_player, player_combination)
    current_player.to_s == player_combination.player1.to_s ? player_combination.player2 : player_combination.player1
  end
end
