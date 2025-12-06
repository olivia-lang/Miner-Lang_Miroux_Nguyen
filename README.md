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

### Modifications & Designs

![uml](https://github.com/olivia-lang/Miner-Lang_Miroux_Nguyen/blob/master/doc/MineSweeper/MineSweeper_UML_placingMines.png)

I introduce new algorithms for placing mines : 
- a mine in each column (if we have a grid of 5x5, we're going to have 5 mines)
- mines are fixed in some position (for i.e (2,2), (4,0) etc.)

We can add more algorithms, so the best solution is to use a Strategy pattern. With this design pattern, we can have a class which will have its own behaviour (here placing mines) but will execute differently according to the algorithm we want (here : randomly, fixed position etc.). Using a Strategy pattern will help the code being more clean - instead of having too many methods for placing mines in **MBox** - and also avoid updating existing code after adding an algorithm. It is the client who will choose which algorithm he wants to play with.

I added a class **PlacingMineStrategy** (which will be the interface) and a subclass **FixedPositionMine** which will implement the logic of the behaviour.
FixedPositionMine has two methods : _positions_ which defines the points where the mines will be placed and _placesMines_ that will replace boxes at a certain position with a mine box.

Then I created a subclass **EachColumnMine** which implements the possibility to put a mine on each column of the board: if the board is 5x5, there is 5 mines, one on each colmun, if the board is 10x10, there will be 10 mines.

I created a subclass **RandomMine** which takes back the behaviour of the method _randomCase_ of **MBox**. The method _placesMines_ there is : 
```
RandomMine >> placesMines : aBoard
	...
	isMine := (0 to: 1) atRandom < (2/8).
	...
	isMine
        ifTrue:  [ aBoard replaceBox: currentBox by: MBox mine ]
        ifFalse: [ aBoard replaceBox: currentBox by: MBox safe ].
```
So we have 2/8 chances to replace the box by a mine box. It is the line <code>isMine := (0 to: 1) atRandom < (2/8).</code> that decides.
> See [tag for this kata](https://github.com/olivia-lang/Miner-Lang_Miroux_Nguyen/releases/tag/Placing-mines-algorithms-v1)

I modify the UI : I added a menu where the player can choose the mine placement. For this, I modify the class **MineSweeper** for the display of the menu and **MBoardElement* to launch the game according to the strategy chosen.
![MineSweeper random](https://github.com/olivia-lang/Miner-Lang_Miroux_Nguyen/blob/master/doc/MineSweeper/MineSweeper_MinesRandom.png)
![MineSweeper fixed](https://github.com/olivia-lang/Miner-Lang_Miroux_Nguyen/blob/master/doc/MineSweeper/MineSweeper_MinsFixedPosition.png)
![MineSweeper column](https://github.com/olivia-lang/Miner-Lang_Miroux_Nguyen/blob/master/doc/MineSweeper/MineSweeper_MinesEachColumn.png)
> See [tag for the UI](https://github.com/olivia-lang/Miner-Lang_Miroux_Nguyen/releases/tag/Placing-mines-algorithms-v2)
### Tests

Initially, there is no tests for the method _randomCase_ because since it randomly places the mine, it can be difficult for the test to define if it is true or false.
I use a set up to avoid repeating code in my tests : 
```
PlacingMineStrategyTest >> setUp
	mBoard := MBoard createWithMatrix: (CTNewArray2D width: 5 height: 5 tabulate: [ :column :row | MBox safe ])
```

I started with the tests for placing mines in fixed position. I wrote the two tests : one that checks the position of the Mbox mine and another that checks if the other boxes doesn't have mines.
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
Then I added two tests for testing placing mines in each column of the board, they are randomly put on a row, so I tested the total number of mines (i.e if it is a 5x5 board, there are 5 mines, not less, not more).

For placing mines randomly on the board, I tested if all the boxes is either a mine or a safe box, since I cannot control the chances. I also tested if the boxes are nil or not, since the logic of the method is to replace nil boxes by safe or mine boxes. I had to add a method _allBoxes_ to run the tests in **MBoard** which returns an array of all the boxes of the board.

### Difficulties

The main difficulty was to modify the UI because I wanted the user to choose the strategy after choosing the board size. I needed to add a menu in between the game and the first menu. I decided to only add in the bar menu. Of course, it has to be modified after implementing the different board size.
I had the problem of when replacing a box, it was not reassigned to the board, so when I cliked on a box, there was an error : #gameEnded was sent to nil, and many pop-ups opened when I clicked on a box. I needed to correct **MBoard >> replaceBox:by:** to reassign board and box positions : 
```
MBoard >> replaceBox: aBox by: aNewBox
	| x y |
	x := aBox position x.
	y := aBox position y.

	aNewBox board: self.
	aNewBox position: aBox position.

	grid at: x @ y put: aNewBox
```
## Introduce the possibility to change the size of the land mine.

### The design before changes

Previously, the board size was "hardcoded" with only one size 5X5.
```
 matrixTest5x5 
	^ self createWithMatrix:
		  (CTNewArray2D width: 5 height: 5 tabulate: [ :column :row |
 			MBox randomCase ])
```
The big problem is the rigidity of the code, if you want another size of board you have to create another classe matrixTest8X8 ... its an explosion of class.

The other problem is that all method launchSmall,launchLarge,LaunchRegular call matrixTest5X5 so it don't make any sense the only thing that difer in those classes is the magnifier.

### Modifications & Designs

I use a Factory Method pattern to handle board creation.

Instead of having subclasses for different sizes, i implemented a class-side method in MBoard. This method take dimensions as parameters (width and height)  
```
width: width height: height
"Create a board with specifid size"
    ^ self createWithMatrix: (CTNewArray2D 
        width: width height: height tabulate: [ :column :row | MBox safe ])
```

