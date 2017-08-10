require './game_runner'

# ruby play.rb will start your game
class Play
  def play
    puts( 'Do you wanna play? y or n')
    result = gets.chomp
    if result == 'y'
      GameRunner.new(:O, nil).play_the_game
    else
      GameRunner.new(:X, nil).play_the_game
    end
  end
end

Play.new.play