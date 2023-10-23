import terminal, strutils

proc initGrid(): array[3, array[3, string]] =
  var
    num = 1
    grid = [
      [" ", " ", " "],
      [" ", " ", " "],
      [" ", " ", " "]
    ]

  # Walks through the rows and columns of the grid, then
  # fills them with a number in the order of 1..9
  for i in 0..2:
    for j in 0..2:
      grid[i][j] = $num
      num += 1
  
  return grid

proc drawGrid(grid: array[3, array[3, string]]) =
  stdout.write("\e[2J\e[H")

  for i in 0..2:
    for j in 0..2:
      stdout.write(grid[i][j])

      if j < 2:
        stdout.write(" | ")
    echo()
    
    if i < 2:
      echo("---------")

proc ticTacToe() =
  var
    grid = initGrid()
    moves = 9
    draw = true

  for m in 1..moves:
    if draw: 
      drawGrid(grid)
    draw = true

    echo("Enter slot number (1-9): ")


    # Get Slot Position in grid
    var
        slot:int
        row: int
        col: int
    try:
        slot = parseInt($getch())
        row = (slot - 1) div 3
        col = (slot - 1) mod 3
    except:
        draw = false
        moves += 1
        echo("Please Choose a Number.")
        continue


    try:
        if grid[row][col] != $slot:
          draw = false
          moves += 1

          echo("Slot taken. Choose another one")
          continue
    except:
        draw = false
        moves += 1

        echo("Please Choose A Number 1-9.")
        continue

    echo("X or O? ")
    var xo = $getch().toUpperAscii()

    if not (xo == "X" or xo == "O"):
      draw = false
      moves += 1
      
      echo("Invalid choice. Must be 'X' or 'O': ")
      continue

    case xo
    of "X": xo = "\e[31mX\e[m"
    of "O": xo = "\e[32mO\e[m"

    grid[row][col] = xo

  drawGrid(grid)
  echo("Game over!")

ticTacToe()