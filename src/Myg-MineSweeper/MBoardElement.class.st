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
	^ self withMatrixTest5x5WithMagnifier: 2
]

{ #category : 'as yet unclassified' }
MBoardElement class >> launchRandomPlacement [
	^ self launchWithStrategy: RandomMine new
]

{ #category : 'instance creation' }
MBoardElement class >> launchRegular [
	^ self withMatrixTest5x5 
]

{ #category : 'instance creation' }
MBoardElement class >> launchSmall [
	"launch with zoom at 0.5"
	^ self withMatrixTest5x5WithMagnifier: 0.5
]

{ #category : 'instance creation' }
MBoardElement class >> launchVeryLarge [
	"launch with zoom at x4"
	^ self withMatrixTest5x5WithMagnifier: 4
]

{ #category : 'as yet unclassified' }
MBoardElement class >> launchWithStrategy: aStrategy [
	| board |
	board := MBoard createWithMatrix: (CTNewArray2D width: 5 height: 5 tabulate: [ :column :row | MBox safe ]).
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

{ #category : 'theme' }
MBoardElement >> applyBoardTheme [ 
	| gameGrid |
	self background: (BlBackground paint: game currentTheme boardColor).
	
	"Update grid background nếu cần"
	gameGrid := self childWithId: #gameGrid ifNone: [ ^ self ].
	"Grid background có thể giữ nguyên hoặc update theo theme"
]

{ #category : 'UI' }
MBoardElement >> createCounterDisplay [ 
	| statsContainer selectionText mineText |
	
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
	
	"Selection counter text"
	selectionText := BlTextElement new text: ('Selections: 0' asRopedText 
		fontSize: (18 * game magnifier);
		fontName: 'Source Sans Pro';
		bold;
		foreground: (Color r: 0.2 g: 0.4 b: 0.8)).
	
	"Mine counter text"
	mineText := BlTextElement new text: (('Mines: ', game mineCount asString) asRopedText 
		fontSize: (18 * game magnifier);
		fontName: 'Source Sans Pro';
		bold;
		foreground: Color red darker).
	
	statsContainer addChild: selectionText.
	statsContainer addChild: mineText.
	
	"Thêm vào main container"
	self addChild: statsContainer.
]

{ #category : 'UI' }
MBoardElement >> createGameGrid [ 
	| gameGridContainer |
	
	gameGridContainer := BlElement new.
	gameGridContainer 
		layout: (BlGridLayout horizontal cellSpacing: 5);
		padding: (BlInsets all: 5 * game magnifier);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].
	
	"Set số cột cho grid"
	gameGridContainer layout columnCount: game width.
	
	"Thêm các box elements vào grid"
	game grid do: [ :aBox |
		| boxElement |
		boxElement := MBoxElement createWithBox: aBox.
		gameGridContainer addChild: boxElement ].
	
	"Lưu id để dễ access sau"
	gameGridContainer id: #gameGrid.
	
	"Thêm grid container vào main container"
	self addChild: gameGridContainer.
]

{ #category : 'accessing' }
MBoardElement >> game [ 
	^ game
]

{ #category : 'accessing' }
MBoardElement >> game: aMBoard [
	"Tạo 2 containers riêng biệt: counterContainer và gameGrid"
	game := aMBoard.
	
	"1. Tạo counter display ở TRÊN"
	self createCounterDisplay.
	
	"2. Tạo game grid container ở DƯỚI"
	self createGameGrid.
	
	"3. Subscribe to announcements"
	game announcer 
		when: MSelectionCountChangedAnnouncement 
		send: #updateCounterDisplay 
		to: self.
	
	game announcer 
		when: MThemeChangedAnnouncement 
		send: #applyBoardTheme 
		to: self.
]

{ #category : 'initialization' }
MBoardElement >> initialize [

	super initialize.
	self background: (BlBackground paint: Color veryVeryLightGray).
	self layout: (BlGridLayout horizontal cellSpacing: 10).
	self constraintsDo: [ :aLayoutConstraints |
		aLayoutConstraints horizontal fitContent.
		aLayoutConstraints vertical fitContent ]
]

{ #category : 'UI' }
MBoardElement >> updateCounterDisplay [ 
	| statsContainer counterText |
	
	statsContainer := self childWithId: #statsContainer ifNone: [ ^ self ].
	counterText := statsContainer allChildrenBreadthFirstDetect: 
		[ :child | (child respondsTo: #id) and: [ child id = #counterText ] ] 
		ifFound: [ :found | found ] 
		ifNone: [ ^ self ].
	
	counterText text: (('Selections: ', game selectionCount asString) asRopedText 
		fontSize: (18 * game magnifier);
		fontName: 'Source Sans Pro';
		bold;
		foreground: (Color r: 0.2 g: 0.4 b: 0.8)).
]
