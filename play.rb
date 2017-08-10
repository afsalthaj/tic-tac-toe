require './game_runner'

# ruby play.rb will start your game
class Play
  def play
    puts( 'Do you wanna play? y or n')
    result = gets.chomp
    if result == 'y'
      game_runner  = GameRunner.new(:O, nil)
      game_runner.projection.display_board(game_runner.game)
      game_runner.play_the_game
    else
      GameRunner.new(:X, nil).play_the_game
    end
  end
end

Play.new.play