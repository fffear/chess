### Ruby Chess Game

This is the final capstone project as part of the Ruby Programming Course at The Odin Project.

This program is a 2 player game, allowing you to play chess with another player on the command line.

At every turn, players will be prompted to enter the coordinates of the piece that they would like to move, followed by the coordinates they would like to move the piece to.

![prompt_to_drop_piece](/screenshots/origin_coordinates.png)

Players also have the option to either resign or propose a draw to the opponent.

![resign_or_propose_draw](/screenshots/resign_and_propose_draw.png)

There will be an option to save the game after every turn.

The game will be properly constrained, which will:
- prevent players from making illegal moves
- declare check and checkmate in the appropriate situations
- declare any draw by stalemate, threefold repetition and by 50 count move rule

## Prerequisite
You will need to have ruby 2.5.3 or above installed to play.

## Install and Play Chess
1. Clone this repository onto your local machine.
1. Navigate to the 'lib' directory located in the root directory on the program
1. Enter ```ruby play_chess.rb```
1. Follow the instructions to play

## Useful Links
Link to [The Odin Project assignment page](https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project)