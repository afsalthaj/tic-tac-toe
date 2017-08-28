require '../game/game.rb'
require '../ui/user_interface'
require '../player/player.rb'
require '../game/game_board.rb'
require '../game_runner/game_runner'
require '../player/player_combination_factory'
require '../strategy/minimax_strategy'
require 'test/unit'

class GameRunnerSpec < Test::Unit::TestCase
  class FakeUi < UserInterface
    def initialize
      @dummy_human_move = -1
    end

    def display_board(board)
      'the board is printed'
    end

    def notify_move_and_return_position
      @dummy_human_move = @dummy_human_move + 1
      @dummy_human_move
    end

    def handle_wrong_moves
      'wrong moves are handled'
    end

    def notify_game_over(board, winner)
       "the exit message is game over and the winner is #{winner}"
    end
  end

  class DummyStrategy < GameStrategy
    def initialize(player_combination, game)
      @player_combination = player_combination
      @game = game
    end

    def next_move(position_in_board)
      if @game.game_over?
        @game
      else
        next_player = switch_player(@game.current_player)
        @game.game_board.play_the_board(position_in_board, @game.current_player.to_s)
        @game.set_current_player(next_player)
        @game
      end
    end

    def switch_player(current_player)
      current_player.to_s == @player_combination.player1.to_s ? @player_combination.player2 : @player_combination.player1
    end
  end

  def test_game_runner_runs_fine_when_players_are_computer_and_human
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.play_the_board(6, player_combination.player1.to_s)
    game_board.play_the_board(1, player_combination.player2.to_s)
    game = Game.new(player_combination.initial_player, game_board)
    strategy = MiniMaxStrategy.new(player_combination, game)
    game_runner = GameRunner.new(FakeUi.new, strategy, game)
    assert_equal(game_runner.run_game, "the exit message is game over and the winner is X")
  end

  def test_game_runner_runs_fine_when_players_are_both_computers
    player_combination = PlayerCombinationFactory.new.get_computer_and_computer("X", "O")
    player_combination.set_initial_player(player_combination.player2)
    game_board = GameBoard.new(3)
    game_board.play_the_board(6, player_combination.player1.to_s)
    game_board.play_the_board(1, player_combination.player2.to_s)
    game = Game.new(player_combination.initial_player, game_board)
    strategy = MiniMaxStrategy.new(player_combination, game)
    game_runner = GameRunner.new(FakeUi.new, strategy, game)
    assert(game_runner.run_game =~ /the exit message is game over and the winner is/)
  end

  def test_game_runner_runs_fine_when_players_are_both_human
    player_combination = PlayerCombinationFactory.new.get_human_and_human("X", "O")
    player_combination.set_initial_player(player_combination.player2)
    game_board = GameBoard.new(3)
    game_board.play_the_board(6, player_combination.player1.to_s)
    game_board.play_the_board(1, player_combination.player2.to_s)
    game = Game.new(player_combination.initial_player, game_board)
    strategy = DummyStrategy.new(player_combination, game)
    game_runner = GameRunner.new(FakeUi.new, strategy, game)
    assert(game_runner.run_game =~ /the exit message is game over and the winner is/)
  end
end