Class {
	#name : 'PlacingMineStrategyTest',
	#superclass : 'TestCase',
	#instVars : [
		'mBoard'
	],
	#category : 'Myg-MineSweeper-Tests',
	#package : 'Myg-MineSweeper-Tests'
}

{ #category : 'running' }
PlacingMineStrategyTest >> setUp [
	super setUp.
	mBoard := MBoard width: 5 height: 5
]

{ #category : 'tests' }
PlacingMineStrategyTest >> testEachColumnHasAMine [
	"check each column of the board has a mine"

	| strategy |
	strategy := EachColumnMine new.
	
	strategy placesMines: mBoard.
	
	1 to: mBoard width do: [:col |
        | minesInColumn |
        minesInColumn := (1 to: mBoard height)
            select: [:row | (mBoard boxAt: col at: row) isMineBox ].

        self assert: minesInColumn size = 1
    ].
]

{ #category : 'tests' }
PlacingMineStrategyTest >> testFixedPositionMinesAreCorrect [
	"test if the mines are placed at the fixed position given"

	| strategy |
	strategy := FixedPositionMine new.
	
	strategy placesMines: mBoard.
	
	strategy positions do: [ :pos | self assert: (mBoard boxAt: pos x at: pos y) isMineBox ]
]

{ #category : 'tests' }
PlacingMineStrategyTest >> testFixedPositionMinesNoOtherMines [
	"test if the mines are no extra mines in other boxes"

	| strategy |
	strategy := FixedPositionMine new.
	
	strategy placesMines: mBoard.
	
	self deny: (mBoard boxAt: 1 at: 1) isMineBox .
	self deny: (mBoard boxAt: 1 at: 2) isMineBox .
	self deny: (mBoard boxAt: 1 at: 4) isMineBox .
	self deny: (mBoard boxAt: 1 at: 5) isMineBox .
]

{ #category : 'tests' }
PlacingMineStrategyTest >> testRandomMineNoNilBoxes [
 	"check when randomly placing mines, boxes are not nil"   
	| strategy |
    strategy := RandomMine new.

    strategy placesMines: mBoard.

    mBoard allBoxes do: [:box | self assert: box notNil ].
]

{ #category : 'tests' }
PlacingMineStrategyTest >> testRandomPlacingMines [
	"check each box of the board is either mine or safe"

	| strategy |
	strategy := RandomMine new.
	
	strategy placesMines: mBoard.
	
	mBoard allBoxes do: [:box |
        self assert: (box isMineBox or: box isSafeBox)
    ].
]

{ #category : 'tests' }
PlacingMineStrategyTest >> testTotalNumberOfMines [
	"check on a board 5x5 there is 5 mines"

	| strategy |
	strategy := EachColumnMine new.
	
	strategy placesMines: mBoard.
	
	self assert: mBoard mineCount = mBoard width.
]
