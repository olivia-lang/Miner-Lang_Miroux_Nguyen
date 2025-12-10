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
Olivia
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

I modify the UI : I added a menu where the player can choose the mine placement. For this, I modify the class **MineSweeper** for the display of the menu and **MBoardElement** to launch the game according to the strategy chosen.
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
Julien
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

(For information, initially I simply wanted to have a **matrixSize: size** method to have the same height and width but I wanted more flexibility in choosing the size.)

I updated/reused the method of Olivia launchWithStrategy: aStrategy to adapt with my new factory method

```
launchWithStrategy: aStrategy width: width height: height
	| board |
	board := MBoard width: width height: height.
	board minePlacementStrategy: aStrategy.
	board applyMinePlacement.
   ^ self openWithModel: board
```

So now in my launchSmall,launchRegular and other launchX method i use launchWithStrategy: aStrategy width: width height: height
```
launchVeryLarge
	"launch with zoom at x4"
	^ self launchWithStrategy: RandomMine new width: 20 height: 20

launchRegular
	^ self launchWithStrategy: FixedPositionMine new width: 8 height: 8
```

Now when you play in Regular mode you will have a board of 8X8 size.

UML : 
![uml](https://github.com/olivia-lang/Miner-Lang_Miroux_Nguyen/blob/master/doc/MineSweeper/MineSwepper_UML_BoardSize.png)


Board with size  12x12 : 

![Board12x12](https://github.com/olivia-lang/Miner-Lang_Miroux_Nguyen/blob/master/doc/MineSweeper/MineSweeper_Board_12x12.PNG)
### Tests
I started to create a class test "MyBoardSizeTest" 

The first test is to verify that we can have any type of size for our board.
```
testCreateBoardWithAnySize
    
    | board |
   
    board := MBoard width: 40 height: 20.
    self assert: board width equals: 40.
    self assert: board height equals: 20.
    self assert: (board boxAt: 40 at: 15) isNotNil.
```

Otherwise i have a test to verify that you can't initilize a board with wrong dimension
```
testInvalidDimensionBoard

self should: [ MBoard width: 0 height: 0 ] raise: Error.
self should: [ MBoard width: -1 height: 5 ] raise: Error.

```

I also created a test testBoardInitializedWithSafeBoxes to be sure that all the box are SafeBoxes after the creation of the board.
And to finish a test to be sure that the strategy are well apply to my board
```
testRandomMineStrategyRespectAnyBoardSize
	 | board strategy |
    board := MBoard width: 20 height: 2.
    strategy := RandomMine new.  
    strategy placesMines: board.
	 "Verify if we have mine"
    self assert: (board allBoxes anySatisfy: [ :box | box isMineBox ]).
```

### Difficulties

One of the difficulty was to use and make it work the magnifier, indeed before in launchSmall,launchLarge we haved a parameter magnifier to adapt the screen(Zoom) according to the size of the board.
It wasn't working before, so for now I've removed it from the game board creation. I think if i understood we have to modify that in **MBoardElement >> game: aMBoard**
So if the magnifier are resolved we can add in **launchWithStrategy: aStrategy** : 
```
^ self openWithModel: board withMagnifier: magnifier
```


### For the future

It would be interesting if, after choosing the size of their board, they could also choose the mines algorithm.
Furthermore, we could add the fact that the user can enter the dimensions of their board themselves.

## Count the boxes selected and the number of mines left
Lan
### The design before changes

Before, the UI calls the Box without any intermediate class, the MVC architecture did not respected because the View calls directly the Control.
```
MBoxElement >> initializeEvents
.....
 self box click  " Call directly, bypass Board"
```
The code also not has a variable to tracking the click. If the user click and reveal one box, the code only count the clicked box, not the revealed (if have) boxes around.

### Modifications & Designs

<img width="2364" height="1644" alt="image" src="https://github.com/user-attachments/assets/24c2645b-f329-47dd-9629-298688934ab6" />
Here, I implimented the MVC architecture with Observe Design Pattern. 

1. First, I refactor method clickOnBox of class MBoard (controller) to calculate the valid clicks. I only count the box that is not opened and not flagged yet. Then I add methods to increment and accessor.
```
MBoard >> clickOnBox: aBox "to calculate the right boxes"
	....
	(boxToClick isClicked not and: [boxToClick isFlagged not])
		ifTrue:  [ self incrementSelectionCount ]. "counting logic"
	boxToClick click.

		>> incrementSelectionCount "increment with notification"
	selectionCount:= selectionCount +1.
	self announcer announce: MSelectionCountChangedAnnouncement new.
	...

		>> selectionCount "accessor"
	^ selectionCount ifNil: [ selectionCount := 0 ]

```
Then, I fixed the MBox (Model) to call through MBoard (Controller) 
```
MBox >> propagateClick
		...
		self board boxesAroundBox: self
			do: [ :box | box isClicked ifFalse: [
				self board clickOnBox: box  ] ] ]
```
The final step to completed my MVC architecture is made the MBoxElement (View) calls through MBoard (Controller)

2. Observe Design Pattern
When **MBoard >> incrementSelectionCount** change, it announces **MSelectionCountChangedAnnouncement**. Then, the subscriber (MBoardElement >> game: aMBoard) send a message update to itself, then trigger the update (updateCounterDisplay).
```
MBoardElement >> game: aMBoard
	...
	game announcer 
		when: MSelectionCountChangedAnnouncement 
		send: #updateCounterDisplay 
		to: self.

			  >> updateCounterDisplay
	...
	counterText text: ((
'Selection: ', game selectionCount asString) ...
```





