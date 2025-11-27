Class {
	#name : 'FixedPositionMine',
	#superclass : 'PlacingMineStrategy',
	#category : 'Myg-MineSweeper',
	#package : 'Myg-MineSweeper'
}

{ #category : 'accessing' }
FixedPositionMine >> placesMines: board [
	self positions do: [ :pos | 
		| currentBox |
		currentBox := board boxAt: pos x at: pos y . board replaceBox: currentBox by: MBox mine ]
	
]

{ #category : 'accessing' }
FixedPositionMine >> positions [
	^ { 1@3 . 2@4 . 3@2 . 4@4 }
	
]
