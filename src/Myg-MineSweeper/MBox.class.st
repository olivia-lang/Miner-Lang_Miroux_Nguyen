"
I am an abstract box held by the mine field.
"
Class {
	#name : 'MBox',
	#superclass : 'MygAbstractBox',
	#instVars : [
		'announcer',
		'flagged',
		'clicked'
	],
	#category : 'Myg-MineSweeper-Model',
	#package : 'Myg-MineSweeper',
	#tag : 'Model'
}

{ #category : 'subclass instance creation' }
MBox class >> mine [
	"create a box with a mine"
	^ MMineBox new
]

{ #category : 'random subclass instance creation' }
MBox class >> randomCase [
	"probability to have a mine in the box is 2/8"
	^ (1 to: 8) atRandom > 6
		  ifTrue: [ self mine ]
		  ifFalse: [ self safe ]
]

{ #category : 'subclass instance creation' }
MBox class >> safe [
	"create a safe box"
	^ MSafeBox new
]

{ #category : 'accessing' }
MBox >> announcer [ 
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'clicking' }
MBox >> click [

	self subclassResponsibility
]

{ #category : 'accessing' }
MBox >> clicked: aBoolean [

	clicked := aBoolean 
]

{ #category : 'accessing' }
MBox >> flag [

	self flagged: self isFlagged not
]

{ #category : 'accessing' }
MBox >> flagged: aBoolean [
	flagged:= aBoolean 
]

{ #category : 'initialization' }
MBox >> initialize [

	flagged := false.
	clicked := false
]

{ #category : 'testing' }
MBox >> isClicked [ 

	^ clicked
]

{ #category : 'testing' }
MBox >> isFlagged [ 
	^ flagged
]

{ #category : 'testing' }
MBox >> isMineBox [
	^ false
]

{ #category : 'testing' }
MBox >> isSafeBox [
	^ false
]

{ #category : 'clicking' }
MBox >> propagateClick [
	"propagate if there is no mine around : open the safe box"
	((self board hasMineBoxAroundBox: self) not or: [
		 self board rightFlagCountAroundBox: self ]) ifTrue: [
		self board
			boxesAroundBox: self
			do: [ :box | 
				box isClicked ifFalse: [ 
					"KEY FIX: Gọi qua board thay vì trực tiếp box click"
					self board clickOnBox: box  "← ĐÂY!" 
				] 
			] 
	]
]
