# The <em>N</em> Queens Conundrum

<div style="float:left;">
  <img align="left" height=200 src="/images/queen1.gif" alt="Queen Image" />
</div>

<div style="float:right;">

> ### PROBLEM STATEMENT:

> Given a chess board of size *N*x*N*,  
> place *N* queens on the board such that no queen threatens any other queen.

> Return any valid representation of the board.

> If such an arrangement is impossible, return false.

</div>

---


<div style="clear: both; float: left">

Example outputs for an input of `4` (4x4 Board):
- 2D array of board "squares"
```ruby
[
  ['-', 'Q', '-', '-'],
  ['-', '-', '-', 'Q'],
  ['Q', '-', '-', '-'],
  ['-', '-', 'Q', '-']
]
```

</div>

- 2D array of coordinates of queen positions [ y, x ]
```ruby
[
  [0, 1],
  [1, 3],
  [2, 0],
  [3, 2]
]
```

- Array of queen objects
```ruby
class Queen
  attr_reader :x, :y

  # ...
end

# output:
[
  #<Queen:0x0055bfa9c7ea70>,
  #<Queen:0x0052a0d9c8b321>,
  #<Queen:0x0056417529ee80>,
  #<Queen:0x0056417529de90>
]
```

- a Board object
```ruby
class Board
  attr_accessor :squares

  # ...
end

# output:
  #<Board:0x0051417513ba23>
```

Solution for `n_queens(8)`:

<img height=300 src="/images/8queens.png" alt="8x8 N Queens Solution" />

> ### NOTE:
> A starter file can be found in the `lib` folder, and if you would like to write tests, a starter test spec can be found in the `spec` folder. Directions to get up and running:
> 1. clone this repository
> 2. `cd N_Queens`
> 3. `bundle`
> 4. To run tests, type `bundle exec rspec` in the root directory of the repository

## Further Explanation:

<img align="right" height=300 src="/images/queenMoves.bmp" alt="Queen Moves" />

The `n` queens puzzle is a famous problem from the world of chess that illustrates the applicability of the algorithm-building techniques called **backtracking search** and **generative recursion**. **Backtracking search** is the process by which you explore multiple paths to a possible solution, and revert back to an earlier position whenever you run into a dead end. **Generative Recursion** is the process of building a list of possible paths to a solution, which are then explored with backtracking search.

For our purposes, a chessboard is a grid of `n` by `n` squares. The queen is a game piece that can move in a horizontal, vertical, or diagonal direction arbitrarily far. We say that a queen threatens a square if it is on the square or can move to it.

The classical queens problem is to place 8 queens on an 8x8 chessboard such that the queens on the board don’t threaten each other. Computer scientists generalize the problem and ask whether it is possible to place `n` queens on a `n`x`n` board.

For `n = 2`, the puzzle obviously has no solution. A queen placed on any of the four squares threatens all remaining squares.

<img align="left" src="/images/3x3.jpeg" alt="3x3 Board" />

There is also no solution for `n = 3`. For a 3x3 board, if you place a queen in the center square, it would threaten all other squares on the board. If instead, you place the first queen on any of the squares around the perimeter, there would be only two remaining squares that the queen would not threaten. The placement of a second queen would threaten all remaining, unoccupied squares, meaning it is impossible to place a third queen.


Now that we have conducted a sufficiently detailed analysis, we can proceed to the solution phase.

---

The analysis suggests several ideas:

The problem is about placing one queen at a time. When we place a queen on a board, we can mark the corresponding rows, columns, and diagonals as unusable for other queens.

When placing the next queen, we consider only non-threatened squares.

Each time we place a queen, there will typically be multiple safe squares to choose from. Because we don't know the solution before we begin, we must have a way to backtrack and choose a different square if our initial square choice makes a solution impossible.

If we are supposed to place a queen on a board but no safe squares are left, we backtrack to a previous point in the process where we chose one square over another and try one of the remaining squares.

If we have checked all possible starting positions, and we have not found a solution, we can determine that a solution is impossible.

## Breaking Down the Problem:
Moving from the process description to a designed algorithm, we need two data representations: one for the chess board and one for the queens on the board. Let’s start with the latter:

```ruby
class Queen
  attr_reader :y, :x

  # @y and @x represent the coordinates
  # of the queen on the given board
  #
  # @y represents the row
  # @x represents the column

  def initialize(y, x)
    @y = y
    @x = x
  end
end
```

### First Exercise:
Design an instance method on the `Queen` class, called `threatens?`. It consumes another instance of the `Queen` class and determines whether or not the other queen would threaten it.
```ruby
class Queen
  # ...

  def threatens?(other_queen)
    # return true or false
  end
end
```

> HINT: Try to use mathematical conditions that relate the queens’ coordinates to each other. For example, all squares on a horizontal have the same y-coordinate. Similarly, all squares on one diagonal have coordinates whose sums are the same. Which diagonal is that? For the other diagonal, the differences between the two coordinates are the same. Which diagonal is that?
>
> Optional: Formulate a test suite that covers horizontals, verticals, and diagonals. Don’t forget to include arguments for which `threatens?` must produce `false`.

---

As for a data representation for Boards, we can construct a class as follows:
```ruby
class Board
  def initialize(n)
    @n = n
    @queens = []
  end
end
```

We actually don't need a full representation for every square on the board because we know the board's dimensions (`@n` x `@n`), and we know the coordinates of every queen on the board. All other squares must be empty.


### Exercise #2:
Design an instance method on the `Board` class that adds a new queen onto the board. This method should not allow a queen to be added if the new queen threatens any other queen currently on the board. Optionally, write a test suite for this functionality.

```ruby
class Board
  # ...

  def add_queen(queen)
    # modify the @queens array
  end
end
```

With our `add_queen` method in place, we can now be sure that on any given board, no two queens threaten each other. This invariant will be important as we formulate other methods to solve the n-queens conundrum.

### Exercise #3:
Design an instance method on the `Board` class that determines whether or not the current board configuration represents a solution to the n-queens problem. Remember, the n-queens problem asks us to place `n` queens on a board of size `n`x`n` such that no two queens threaten each other. As always, write tests if you want to confirm that your method is working correctly.

```ruby
class Board
# ...

  def solved?
    # return true or false
  end
end
```

### Exercise #4:
Now we are getting into the meat of the problem. In order to use generative recursion, we must first **generate** a list of next possible moves. The "next move" in our case is adding another queen to the board. A queen may be added to the board on any square that is not threatened by the existing queens. Write an instance method called `next_queens` on the `Board` class that returns an array of possible `Queen`s that we could add to the board as our next move.

Since we don't know which of these `Queen`s are part of the final solution or which ones would make a solution impossible, we will later explore the possible `Queen`s one-by-one and backtrack if we hit a dead end.

> Example Output:
>
> if the safe squares on the board are at coordinates [0, 1] and [5, 3]
>
> `next_queens` would return `[ Queen.new(0, 1), Queen.new(5, 3) ]`

```ruby
class Board
  # ...

  def next_queens
    # return an array of Queens that we could use
    # for our next move
  end
end
```

---

In order to implement backtracking search, we will use recursion. We will implement the final algorithm to solve this challenge in a method called `n_queens`. Inside the `n_queens` method, we will iterate through each `Queen` returned from the `next_queens` method, and we will perform the following actions with each `Queen` in the array:
1. clone the current board
2. add the current `Queen` to the cloned `Board` (we'll call the new board `cloned_board`)
3. call the `cloned_board.n_queens` method

Before we try to tackle the final algorithm, let's write an instance method on the `Board` class that will allow us to clone our board before we add new queens to it.

### Exercise #5:
Implement the `Board#clone` instance method.

```ruby
class Board
  # ...

  def clone
    # return a new board with the same configuration
    # as the current board
  end
end
```

---

One last thing before we begin writing the algorithm to solve the n-queens conundrum. We need a way to render our board so we can see what it looks like.

### Exercise #6:
Write a `Board#to_s` instance method that will return a string version of the current board.

```ruby
class Board
  # ...

  def to_s
    # translate the board state into a string
  end
end
```

---

<img align="left" height=180 src="/images/queenSketch.jpeg" alt="3x3 Board" />

All right! We are almost there.

Next, we are going to put it all together and write an instance method on the `Board` class called `n_queens` that will return either:

      - a solved board
      - false (if the board is unsolvable)

---

### Final Exercise:
Implement the n_queens algorithm!!!

```ruby
class Board
  # ...

  def n_queens
    # solve the conundrum
  end
end
```

> ### HINT:
>
> The general formula for the algorithm should be as follows:
>
> 1. Check if the board is solved already.
>    - If so, return the solved board
> 2. Generate a list of next possible (valid) Queens that you can add to the board
> 3. For each possible next queen:
>    - clone the current board
>    - add the queen to the cloned board
>    - call `cloned_board.n_queens` and assign the result to a variable (let's call it `result`)
>    - check `result`: if it is not false, return the result. otherwise, move on to the next queen in the array
> 4. If all the possible queens have been tried without success, return `false`



*Acknowledgements:*

*Problem and explanation adapted from http://www.ccs.neu.edu/home/matthias/HtDP2e/part_five.html*
