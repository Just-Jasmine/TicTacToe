import terminal, strutils, random

# adds the X or O to the grid
proc xoPrint(ptrArray: array[3, ptr], xo: ptr, grid: ptr) =
  case xo[]
  of "X": xo[] = "\e[31mX\e[m"
  of "O": xo[] = "\e[32mO\e[m"
  grid[][ptrArray[1][]][ptrArray[2][]] = xo[]
  return

# Selects a the slot from the 3 by 3 array
proc chooseSlot(ptrArray: array[3, ptr]) =
  ptrArray[1][] = (ptrArray[0][] - 1) div 3
  ptrArray[2][] = (ptrArray[0][] - 1) mod 3
  return

# Executes ai turn Logic
proc aiMove() =
  return

# Executes player turn Logic
proc playerMove(ptrArray: array[3, ptr], draw: ptr, turns: ptr, grid: ptr) =
  try:
    echo("Enter slot number (1-9): ")
    ptrArray[0][] = parseInt($getch())
    chooseSlot(ptrArray)
    return
  except:
    draw[] = false
    turns[] += 1
    return
  try:
    if grid[][ptrArray[1][]][ptrArray[2][]] != $ptrArray[0][]:
      draw[] = false
      turns[] += 1
      echo("Slot taken. Choose another one: ")
      return
  except:
    draw[] = false
    turns[] += 1
    echo("Please choose a number 1-9: ")
    return

# returns an initial 3 by 3 array
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

# uses for loops to draw a 3 by 3 array passed to it
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

# Main function
proc ticTacToe() =
  # Initializes variables
  var
    grid = initGrid()
    turns = 9
    draw = true
    aiTurn = false
    aiEnabled = false
    xo: string
    slot: int
    row: int
    col: int

  # Welcomes the user and asks if they want ai enabled
  while (true):
    echo("Welcome to TicTacToe. Enable AI?(Y/N): ")
    try:
      case $getch().toUpperAscii()
      of "Y":
        aiEnabled = true
        break
      of "N":
        aiEnabled = false
        break
      else:
        echo("Please enter Y or N: ")
    except:
      echo("Please enter Y or N: ")
      continue

  # Asks the user what character they want to use, X or 0
  while (true):
    echo("X or O?: ")
    try:
      case $getch().toUpperAscii()
      of "X":
        xo = "X"
        break
      of "O":
        xo = "O"
        break
      else:
        echo("Please enter X or O: ")
        continue
    except:
      echo("Please enter X or O: ")
      
  # Loops for how many turns are left
  for t in 1..turns:
    # draws a grid if draw is true
    if draw: 
      drawGrid(grid)
    draw = true
    
    # Checks if it's the AI's turn, and executes if it isn't
    if (aiTurn != true):
      var ptrArray = [addr(slot), addr(row), addr(col)]
      playerMove(ptrArray, addr(draw), addr(turns), addr(grid))
      xoPrint(ptrArray, addr(xo), addr(grid))
      aiMove()

      if aiEnabled:
        aiTurn = true

  drawGrid(grid)
  echo("Game over!")

ticTacToe()