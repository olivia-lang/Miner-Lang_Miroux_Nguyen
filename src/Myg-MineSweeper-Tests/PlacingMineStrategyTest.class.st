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
	
	mBoard := MBoard createWithMatrix: (CTNewArray2D width: 5 height: 5  tabulate: [ :column :row | MBox safe ])
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
