"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	game:		<Object>


    Implementation Points
"
Class {
	#name : 'MBoardElement',
	#superclass : 'BlElement',
	#instVars : [
		'game'
	],
	#category : 'Myg-MineSweeper-UI',
	#package : 'Myg-MineSweeper',
	#tag : 'UI'
}

{ #category : 'as yet unclassified' }
MBoardElement class >> launchEachColumnPlacement [
	^ self launchWithStrategy: EachColumnMine new
]

{ #category : 'as yet unclassified' }
MBoardElement class >> launchFixedPositionPlacement [
	^ self launchWithStrategy: FixedPositionMine new
]

{ #category : 'instance creation' }
MBoardElement class >> launchLarge [
	"launch with zoom x2"
	^ self launchWithStrategy: RandomMine new width: 12 height: 12
]

{ #category : 'as yet unclassified' }
MBoardElement class >> launchRandomPlacement [
	^ self launchWithStrategy: RandomMine new
]

{ #category : 'instance creation' }
MBoardElement class >> launchRegular [
	^ self launchWithStrategy: FixedPositionMine new width: 8 height: 8
]

{ #category : 'instance creation' }
MBoardElement class >> launchSmall [
	"launch with zoom at 0.5"
	^ self launchWithStrategy: RandomMine new width: 5 height: 5
]

{ #category : 'instance creation' }
MBoardElement class >> launchVeryLarge [
	"launch with zoom at x4"
	^ self launchWithStrategy: RandomMine new width: 20 height: 20
]

{ #category : 'as yet unclassified' }
MBoardElement class >> launchWithStrategy: aStrategy [
	| board |
	board := MBoard createWithMatrix: (CTNewArray2D width: 5 height: 5 tabulate: [ :column :row | MBox safe ]).
	board minePlacementStrategy: aStrategy.
	board applyMinePlacement.
	^ self openWithModel: board
]

{ #category : 'as yet unclassified' }
MBoardElement class >> launchWithStrategy: aStrategy width: width height: height [
	| board |
	board := MBoard width: width height: height.
	board minePlacementStrategy: aStrategy.
	board applyMinePlacement.
   ^ self openWithModel: board
]

{ #category : 'instance creation' }
MBoardElement class >> open [
	"open and manage the menu to select the size, open the game"
	<script>

	| butSmall butRegular butLarge butVeryLarge space elt |
	butSmall := ToButtonModel new.
	butSmall labelText: ('Small' asRopedText fontSize: 50).
	butSmall whenClickedDo: [ self launchSmall ].

	butRegular := ToButtonModel new.
	butRegular labelText: ('Regular' asRopedText fontSize: 50).
	butRegular whenClickedDo: [ self launchRegular ].

	butLarge := ToButtonModel new.
	butLarge labelText: ('Large' asRopedText fontSize: 50).
	butLarge whenClickedDo: [ self launchLarge ].

	butVeryLarge := ToButtonModel new.
	butVeryLarge labelText: ('Very Large' asRopedText fontSize: 50).
	butVeryLarge whenClickedDo: [ self launchVeryLarge ].

	elt := BlElement new.
	elt layout: (BlGridLayout horizontal cellSpacing: 5).
	elt constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	elt layout columnCount: 2.

	space := BlSpace new.
	elt addChild: (butSmall onWidget
			 padding: (BlInsets all: 5);
			 constraintsDo: [ :c |
				 c horizontal matchParent.
				 c vertical matchParent ];
			yourself).
	elt addChild:
		(butRegular onWidget
			padding: (BlInsets all: 5);
			constraintsDo: [ :c |
				 c horizontal matchParent.
				 c vertical matchParent ];
			yourself).
	elt addChild:
		(butLarge onWidget
			padding: (BlInsets all: 5);
			constraintsDo: [ :c |
				 c horizontal matchParent.
				 c vertical matchParent ];
			yourself).
	elt addChild:
		(butVeryLarge onWidget
			padding: (BlInsets all: 5);
			constraintsDo: [ :c |
				c horizontal matchParent.
				c vertical matchParent ];
			yourself).
	space root addChild: elt.
	space extent: 500 @ 250.
	space show
]

{ #category : 'instance creation' }
MBoardElement class >> openWithModel: aModel [
	"open a MBoard with zoom at x1"
	^ self openWithModel: aModel withMagnifier: 1
]

{ #category : 'instance creation' }
MBoardElement class >> openWithModel: aModel withMagnifier: aNumber [
	"open a MBoard with a zoom given"
	| aGameElement space |
	space := BlSpace new.
	"Create the game model and the Bloc element."
	aGameElement := self new
		                game: (aModel magnifier: aNumber);
		                yourself.

	"The space represents the window"

	space root addChild: aGameElement.

	"Calculate the extent of the game board for the first time, to set it to the window."
	space pulse.
	space extent: aGameElement extent.
	space resizable: false.
	space show.
	^ space
]

{ #category : 'execution' }
MBoardElement class >> withMatrixForField [

	^ self openWithModel: MBoard matrixForField
]

{ #category : 'execution' }
MBoardElement class >> withMatrixForFieldWithMagnifier: aNumber [

	^ self openWithModel: MBoard matrixForField withMagnifier: aNumber 
]

{ #category : 'execution' }
MBoardElement class >> withMatrixTest5x5 [

	^ self openWithModel: MBoard matrixTest5x5
]

{ #category : 'execution' }
MBoardElement class >> withMatrixTest5x5WithMagnifier: aNumber [

	^ self openWithModel: MBoard matrixTest5x5 withMagnifier: aNumber 
]

{ #category : 'as yet unclassified' }
MBoardElement >> createCounterDisplay [
	|statsContainer selectionText mineText |
	
	"container for stats"
	statsContainer := BlElement new.
	statsContainer 
		layout: (BlLinearLayout horizontal cellSpacing: 20);
		background: (Color r: 0.95 g: 0.95 b: 0.98);
		border: (BlBorder paint: Color gray width: 2);
		geometry: (BlRoundedRectangleGeometry cornerRadius: 8);
		padding: (BlInsets all: 15 * game magnifier);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ];
		id: #statsContainer.
		
	"selection counter text"
	selectionText := BlTextElement new text: ('Selections: 0' asRopedText 
		fontSize: (18 * game magnifier);
		fontName: 'Source Sans Pro';
		bold;
		foreground: (Color r: 0.2 g: 0.4 b: 0.8)).
	selectionText id: #counterText.
	
	
	"mine counter text"
	mineText := BlTextElement new text: (('Mines: ', game mineCount asString) asRopedText 
		fontSize: (18 * game magnifier);
		fontName: 'Source Sans Pro';
		bold;
		foreground: Color red darker).

	statsContainer addChild: selectionText.
	statsContainer addChild: mineText.
	
	"add main container"
	self addChild: statsContainer. 
	
	
	
	 
]

{ #category : 'as yet unclassified' }
MBoardElement >> createGameGrid [
| gameGridContainer |
	
	gameGridContainer := BlElement new.
	gameGridContainer 
		layout: (BlGridLayout horizontal cellSpacing: 5);
		padding: (BlInsets all: 5 * game magnifier);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].
	
	"set number columns for grid"
	gameGridContainer layout columnCount: game width.
	
	"add box elements to grid"
	game grid do: [ :aBox |
		| boxElement boxSize |
		boxSize := 50 * game magnifier.
		boxElement := MBoxElement createWithBox: aBox.
		boxElement size: boxSize @ boxSize.
		gameGridContainer addChild: boxElement ].
	
	"save id in prder to easier acces after"
	gameGridContainer id: #gameGrid.
	
	"add grid container to main container"
	self addChild: gameGridContainer. 
]

{ #category : 'accessing' }
MBoardElement >> game [ 
	^ game
]

{ #category : 'accessing' }
MBoardElement >> game: aMBoard [
	"store the model and adjust the padding according to the zoom
	 show the UI"
	
	" creat 2 container separately: counterContainer and gameGrid"
	game := aMBoard.
	"1. create counter display above"
	self createCounterDisplay.
	"2. create game grid container below"
	self createGameGrid.
	"3. subscribe to announcements"
	game announcer 
		when: MSelectionCountChangedAnnouncement 
		send: #updateCounterDisplay 
		to: self.
	
	
]

{ #category : 'initialization' }
MBoardElement >> initialize [

	super initialize.
	self background: (BlBackground paint: Color veryVeryLightGray).
	self layout: (BlGridLayout horizontal cellSpacing: 5).
	self padding: (BlInsets all:10).
	self constraintsDo: [ :aLayoutConstraints |
		aLayoutConstraints horizontal fitContent.
		aLayoutConstraints vertical fitContent ]
]

{ #category : 'as yet unclassified' }
MBoardElement >> updateCounterDisplay [
	|statsContainer counterText|
	
"query UI elements by ID"
statsContainer:= self childWithId: #statsContainer ifNone: [ ^self ].
counterText := statsContainer childWithId: #counterText ifNone: [ ^self ].

"update text content"
counterText text: ((
'Selection: ', game selectionCount asString) asRopedText 
fontSize: (18* game magnifier);
fontName: 'Source Sans Pro';
bold;
foreground: (Color r:0.2 g:0.4 b:0.8)
).

]
