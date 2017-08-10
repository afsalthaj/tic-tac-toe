# My Tic-Tac-Toe in Ruby

This is a tic-tac-toe with a command line interface 
that lets you play a tic-tac-toe with the computer.

The implementation is done in Ruby using the min-max algorithm.

# Strategy
* Computer plays all the future games the moment you start the game.
* Computer plays its initial move. This is inspired from many tic-tac-toe
games available in the internet. I consider this as a limitation and will fix it soon.
* Computer ranks all the moves, and depending the player, it choose the move
with either the maximum score, or minimum score. Maximum score if next move is "Computer's"
else minimum.
* The computer player is hard-coded as :X and the user is identified as :O

## Pros 
* Minimax algorithm is fairly intuitive in nature though it sounds a bit advanced, 
and lets you build a recursive algorithm and lets you build the game with less code
* Computer always wins!

# Game Runner
Game Runner is sort of a client of Tic tac toe `Game` that makes use
of the strategy and the game. 
Game class is responsible for keeping track of the state of the game.
Obviously state of the game is represented by the player, the board and the 
complete set of moves available at a point in time.

# Reference
* https://www.youtube.com/watch?v=zDskcx8FStA
* https://www.quora.com/Is-there-a-simple-explanation-of-a-minimax-algorithm
* https://en.wikipedia.org/wiki/Minimax (as a last resort)

# Technical Debts
* It seems the algorithm selected is quite advanced, and is not scalable.
* The first iteration of every game starts in 20 seconds, which is not so good.
* Remove command line and include a canvas