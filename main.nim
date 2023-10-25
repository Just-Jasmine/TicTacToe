import terminal, strutils, random


# Selects a the slot from the 3 by 3 array
proc chooseSlot(slot: int, grid: ptr): array[2, int] =
  var 
    row = (slot - 1) div 3
    col = (slot - 1) mod 3
  return [row, col]

# adds the X or O to the grid
proc xoPrint(slot: int, xo: string, grid: ptr) =
  # Sets Color
  var 
    xoc = xo
  case xoc
  of "X":
    xoc = "X" 
    xoc = "\e[31mX\e[m"
  of "O":
    xoc = "O" 
    xoc = "\e[32mO\e[m"
  var rowCol = chooseSlot(slot, grid)
  grid[][rowCol[0]][rowCol[1]] = xoc

# Executes ai turn Logic
proc aiMove(draw: ptr, turns: ptr, grid: ptr): int =
  var 
    slot: int
  if grid[][1][1] == "5":
    slot = 5
  else:
    while(true):
      randomize()
      slot = rand(1..9)
      var rowCol = chooseSlot(slot, grid)
      if grid[][rowCol[0]][rowCol[1]] != $slot:
        continue
      break
  return slot
  
# Executes player turn Logic
proc playerMove(draw: ptr, turns: ptr, grid: ptr): int =

  var
    slot: int
    row: int
    col: int
    rowCol: array[2, int]
  while(true):
    try:
      echo("Enter slot number (1-9): ")
    # slot = character as an int
      slot = parseInt($getch())
    except:
      draw[] = false
      turns[] += 1
      continue
    rowCol = chooseSlot(slot, grid)
    row = rowCol[0]
    col = rowCol[1]
    try:
      if grid[][row][col] != $slot:
        draw[] = false
        turns[] += 1
        echo("Please choose an unused slot: ")
        continue
    except:
      echo("Please use a number 1-9: ")
      return slot









    #[
    try:
      if grid[][rowCol[0]][rowCol[1]] != $slot:
        draw[] = false
        turns[] += 1
        echo("Slot taken. Choose another one: ")
        continue
      break
    except:
      draw[] = false
      turns[] += 1
      echo("Please choose a number 1-9: ")
      continue
    ]#
    return slot

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
        xo = "O"
        break
      of "O":
        xo = "X"
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
      if xo == "X":
        xo = "O"
      else:
        xo = "X"
      slot = playerMove(addr(draw), addr(turns), addr(grid))
      xoPrint(slot, xo, addr(grid))
      if aiEnabled:
        aiTurn = true
    # Executes on AI's turn
    else:
      if xo == "X":
        xo = "O"
      else:
        xo = "X"
      slot = aiMove(addr(draw), addr(turns), addr(grid))
      xoPrint(slot, xo, addr(grid))
      aiTurn = false


  drawGrid(grid)
  echo("Game over!")


ticTacToe()