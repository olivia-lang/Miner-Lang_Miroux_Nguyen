Class {
	#name : 'EachColumnMine',
	#superclass : 'PlacingMineStrategy',
	#category : 'Myg-MineSweeper',
	#package : 'Myg-MineSweeper'
}

{ #category : 'as yet unclassified' }
EachColumnMine >> placesMines: aBoard [
	 1 to: aBoard width do: [ :col |
        | row currentBox|
			row := (1 to: aBoard height) atRandom.
			currentBox := aBoard boxAt: col at: row . aBoard replaceBox: currentBox by: MBox mine
    ].
]
