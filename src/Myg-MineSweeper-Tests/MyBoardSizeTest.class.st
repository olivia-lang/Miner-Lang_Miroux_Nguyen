Class {
	#name : 'MyBoardSizeTest',
	#superclass : 'TestCase',
	#category : 'Myg-MineSweeper-Tests',
	#package : 'Myg-MineSweeper-Tests'
}

{ #category : 'tests' }
MyBoardSizeTest >> testBoardInitializedWithSafeBoxes [
	 | board |
    board := MBoard width: 3 height: 3.
    board allBoxes do: [ :box | 
        self assert: box class equals: MSafeBox.
        self assert: box position isNotNil.
    ].
    
    self assert: board allBoxes size equals: 9.
]

{ #category : 'tests' }
MyBoardSizeTest >> testCreateBoardWithAnySize [
    
    | board |
   
    board := MBoard width: 40 height: 20.
    self assert: board width equals: 40.
    self assert: board height equals: 20.
    self assert: (board boxAt: 40 at: 15) isNotNil.
]

{ #category : 'tests' }
MyBoardSizeTest >> testInvalidDimensionBoard [

self should: [ MBoard width: 0 height: 0 ] raise: Error.
self should: [ MBoard width: -1 height: 5 ] raise: Error.
]

{ #category : 'tests' }
MyBoardSizeTest >> testRandomMineStrategyRespectAnyBoardSize [
	 | board strategy |
    board := MBoard width: 20 height: 2.
    strategy := RandomMine new.  
    strategy placesMines: board.
	 "Verify if we have mine"
    self assert: (board allBoxes anySatisfy: [ :box | box isMineBox ]).
]
