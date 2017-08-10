# My Tic-Tac-Toe in Ruby

This is a tic-tac-toe with a command line interface 
that lets you play a tic-tac-toe with the computer.

The implementation is done in Ruby using the min-max algorithm.

# Start playing
* Install Ruby (Ex: In Mac, brew install ruby)
* Clone the project 

```

git clone https://github.com/afsalthaj/tic-tac-toe

```
* Play game

```
cd tic-tac-toe
ruby play.rb

```

# Strategy
* Computer plays all the future games the moment you start the game.
* Computer plays its initial move. This is inspired from many tic-tac-toe
games available in the internet. I consider this as a limitation and will fix it soon.
* Computer ranks all the moves, and depending the player, it choose the move
with either the maximum score, or minimum score. Maximum score if next move is "Computer's"
else minimum.
* The computer player is hard-coded as :X and the user is identified as :O

## Pros 
* Minimax algorithm is fairly intuitive and recursive.
* Lets you build a strategy to win the game.
* Computer always wins!

## Cons
* Not so intuitive in code
* First stage computations taking time. Depth factor can be incorporated.

# Game Runner
Game Runner is sort of a client of Tic tac toe `Game` that makes use
of the strategy and the game. 
Game class is responsible for keeping track of the state of the game.
Obviously state of the game is represented by the player, the board and the 
complete set of moves available at a point in time.

# TODO
* It seems the algorithm selected is quite advanced, and is not scalable.
* The first iteration of every game starts in 20 seconds, which is not so good.
* Remove command line and include a canvas
* Mock command line input output testing rspec

# Test Coverage
* All that I did here is, simulating a game in test case, and asserting each moves/possible moves.
* Asserting each move/possible move is done intuitively and did't focus much on min-max algorithm.
* File "game.rb" and "game_runner.rb" are the ones tested. File "play.rb" is just invoking the game.

Run tests by:

```shell

// In the root directory

// Optional command
brew install ruby
bundle install

//run tests
ruby spec.rb

// get the coverage report
cd coverage
open index.html

```

# Reference
* https://www.quora.com/Is-there-a-simple-explanation-of-a-minimax-algorithm 
* https://www.youtube.com/watch?v=zDskcx8FStA
* https://en.wikipedia.org/wiki/Minimax