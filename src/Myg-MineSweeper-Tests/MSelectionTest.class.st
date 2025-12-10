Class {
	#name : 'MSelectionTest',
	#superclass : 'TestCase',
	#instVars : [
		'count',
		'board'
	],
	#category : 'Myg-MineSweeper-Tests',
	#package : 'Myg-MineSweeper-Tests'
}

{ #category : 'as yet unclassified' }
MSelectionTest >> incrementCount [ 
	count:= count+1

]

{ #category : 'as yet unclassified' }
MSelectionTest >> setUp [ 
	super setUp.
	board := MBoard width: 3 height: 3.
	"set mines" board replaceBox: (board boxAt: 2 at: 2) by: MBox mine.
	count := 0


]

{ #category : 'as yet unclassified' }
MSelectionTest >> testDoesNotCountClickedAndFlaggedBox [
	| box1 box2|
	box1 := board boxAt: 1 at: 1.
	board clickOnBox: box1. "click one, count 1"
	board clickOnBox: box1. "click two, dont count"
	
	box2 := board boxAt: 1 at: 2.
	box2 flag.
	board clickOnBox: box2. "flagged, dont count"
	
	self assert: board selectionCount equals: 1.



]

{ #category : 'as yet unclassified' }
MSelectionTest >> testIncrement [ 
	board clickOnBox: (board boxAt: 1 at: 1).
self assert: board selectionCount equals: 1




]

{ #category : 'as yet unclassified' }
MSelectionTest >> testIncrement2 [
	board clickOnBox: (board boxAt: 1 at: 1).
	board clickOnBox: (board boxAt: 1 at: 2).
	board clickOnBox: (board boxAt: 2 at: 1).
self assert: board selectionCount equals: 3

]

{ #category : 'as yet unclassified' }
MSelectionTest >> testInitializeCountIsZero [ 
	self assert: board selectionCount equals: 0 


]

{ #category : 'as yet unclassified' }
MSelectionTest >> testObserveDesignPattern [
	board announcer 
		when: MSelectionCountChangedAnnouncement 
		send: #incrementCount
		to: self.
		
	board clickOnBox: (board boxAt: 1 at: 1).
	self assert: count equals: 1

]
