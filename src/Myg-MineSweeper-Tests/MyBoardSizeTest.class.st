Class {
	#name : 'MyBoardSizeTest',
	#superclass : 'TestCase',
	#category : 'Myg-MineSweeper-Tests',
	#package : 'Myg-MineSweeper-Tests'
}

{ #category : 'tests' }
MyBoardSizeTest >> testCreateBoardWithAnySize [
    
    | board |
   
    board := MBoard width: 40 height: 20.
    self assert: board width equals: 40.
    self assert: board height equals: 20.
    self assert: (board boxAt: 40 at: 15) isNotNil.
]
