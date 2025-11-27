## Loading the project 

For development, load master branch:

```Smalltalk
Metacello new
	repository: 'github://olivia-lang/Miner-Lang_Miroux_Nguyen';
	baseline: 'Myg';
	onConflictUseLoaded;
	load.
```
Launch the game : 

```Smalltalk
MineSweeper open
```

## Introduce different algorithms for placing mines
### Existing method

There is one method for placing mines in the **MBox** class : 
```
randomCase
   ^ (1 to: 8) atRandom > 6
         ifTrue: [ self mine ]
         ifFalse: [ self safe ]
```
It randomly places the mines on the board, with 2 chances out of 8 to have a mine. It is the box who decides if it will contain a mine or not.

This method is called in **MBoard** class : 
```
 matrixTest5x5 
	^ self createWithMatrix:
		  (CTNewArray2D width: 5 height: 5 tabulate: [ :column :row |
 			MBox randomCase ])
``` 

### Tests

There is no tests for the method _randomCase_ because since it randomly places the mine, it can ba difficult for the test to define if it is true or false.

### Modifications & Designs

I introduce new algorithms for placing mines : 
- a mine in each column (if we have a grid of 5x5, we're going to have 5 mines)
- mines are fixed in some position (for i.e (2,2), (4,0) etc.)
- having a cluster of mines (mines are gathered)

We can add more algorithms, so the best solution is to use a Strategy pattern. With this design pattern, we can have a class which will have its own behaviour (here placing mines) but will execute differently according to the algorithm we want (here : randomly, fixed position etc.). Using a Strategy pattern will help the code being more clean - instead of having too many methods for placing mines in **MBox** - and also avoid updating existing code after adding an algorithm. It is the client who will choose which algorithm he wants to play with.

I started with placing mines in fixed position. I wrote the two tests : one that checks the position of the Mbox mine and another that checks if the other boxes doesn't have mines.
```
PlacingMineStrategyTest >> testFixedPositionMinesAreCorrect

	| strategy |
	strategy := FixedPositionMine new.
	
	strategy placesMines: mBoard.
	
	strategy positions do: [ :pos | self assert: (mBoard boxAt: pos x at: pos y) isMineBox ]

PlacingMineStrategyTest >> testFixedPositionMinesNoOtherMines

	| strategy |
	strategy := FixedPositionMine new.
	
	strategy placesMines: mBoard.
	
	self deny: (mBoard boxAt: 1 at: 1) isMineBox .
	self deny: (mBoard boxAt: 1 at: 2) isMineBox .
	self deny: (mBoard boxAt: 1 at: 4) isMineBox .
	self deny: (mBoard boxAt: 1 at: 5) isMineBox .
``` 
I added a class PlacingMineStrategy (which will be the interface) and a subclass FixedPositionMine which will implement the logic of the behaviour.
FixedPositionMine has two methods : _positions_ which defines the points where the mines will be placed and _placesMines_ that will replace boxes at a certain position with a mine box.
