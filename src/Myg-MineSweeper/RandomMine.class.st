Class {
	#name : 'RandomMine',
	#superclass : 'PlacingMineStrategy',
	#category : 'Myg-MineSweeper',
	#package : 'Myg-MineSweeper'
}

{ #category : 'as yet unclassified' }
RandomMine >> placesMines: aBoard [
	1 to: aBoard width do: [:x |
        1 to: aBoard height do: [:y |
            | isMine currentBox |isMine := (0 to: 1) atRandom < (2/8).

				currentBox := aBoard boxAt: x  at: y . 
            isMine
                ifTrue:  [ aBoard replaceBox: currentBox by: MBox mine ]
                ifFalse: [ aBoard replaceBox: currentBox by: MBox safe ].
        ]].
]
