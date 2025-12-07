Class {
	#name : 'MineSweeperTheme',
	#superclass : 'Object',
	#instVars : [
		'name',
		'boxColor',
		'clickedBoxColor',
		'boardColor',
		'numberColors'
	],
	#category : 'Myg-MineSweeper-UI',
	#package : 'Myg-MineSweeper',
	#tag : 'UI'
}

{ #category : 'instance creation' }
MineSweeperTheme class >> classic [
	"Theme cổ điển Windows 98 style"
	^ self new
		name: 'Classic';
		boxColor: Color lightGray;
		clickedBoxColor: (Color white darker darker);		boardColor: Color veryVeryLightGray;
		numberColors: {
			Color blue.      "1"
			Color green darker.   "2"
			Color red.       "3"
			Color blue darker darker. "4"
			Color red darker darker.  "5"
			Color cyan darker.        "6"
			Color black.              "7"
			Color gray darker.        "8"
		};
		yourself
]

{ #category : 'accessing' }
MineSweeperTheme class >> dark [
	"Theme tối hiện đại"
	^ self new
		name: 'Dark';
		boxColor: (Color r: 0.2 g: 0.2 b: 0.25);
		clickedBoxColor: (Color r: 0.15 g: 0.15 b: 0.2);
		boardColor: (Color r: 0.1 g: 0.1 b: 0.15);
		numberColors: {
			(Color r: 0.4 g: 0.7 b: 1.0).  "1 - Light blue"
			(Color r: 0.4 g: 1.0 b: 0.6).  "2 - Light green"
			(Color r: 1.0 g: 0.5 b: 0.5).  "3 - Light red"
			(Color r: 0.6 g: 0.4 b: 1.0).  "4 - Purple"
			(Color r: 1.0 g: 0.7 b: 0.3).  "5 - Orange"
			(Color r: 0.3 g: 0.9 b: 0.9).  "6 - Cyan"
			(Color r: 0.9 g: 0.9 b: 0.9).  "7 - White"
			(Color r: 0.7 g: 0.7 b: 0.7).  "8 - Gray"
		};
		yourself
]

{ #category : 'accessing' }
MineSweeperTheme class >> ocean [ 
	^ self new
		name: 'Ocean';
		boxColor: (Color r: 0.7 g: 0.85 b: 0.95);
		clickedBoxColor: (Color r: 0.8 g: 0.9 b: 1.0);
		boardColor: (Color r: 0.4 g: 0.6 b: 0.8);
		numberColors: {
			(Color r: 0.0 g: 0.3 b: 0.6).   "1"
			(Color r: 0.0 g: 0.5 b: 0.5).   "2"
			(Color r: 0.2 g: 0.4 b: 0.7).   "3"
			(Color r: 0.1 g: 0.2 b: 0.5).   "4"
			(Color r: 0.3 g: 0.5 b: 0.8).   "5"
			(Color r: 0.0 g: 0.4 b: 0.7).   "6"
			(Color r: 0.1 g: 0.3 b: 0.5).   "7"
			(Color r: 0.2 g: 0.4 b: 0.6).   "8"
		};
		yourself
]

{ #category : 'accessing' }
MineSweeperTheme >> boardColor [ 
	^ boardColor
]

{ #category : 'accessing' }
MineSweeperTheme >> boardColor: aColor [
	boardColor := aColor
	
]

{ #category : 'accessing' }
MineSweeperTheme >> boxColor [ 
	^ boxColor
]

{ #category : 'accessing' }
MineSweeperTheme >> boxColor: aColor [
	boxColor := aColor
]

{ #category : 'accessing' }
MineSweeperTheme >> clickedBoxColor [ 
	^ clickedBoxColor
]

{ #category : 'accessing' }
MineSweeperTheme >> clickedBoxColor: aColor [
	clickedBoxColor := aColor
]

{ #category : 'accessing' }
MineSweeperTheme >> colorForNumber: aNumber [ 
	"Returns the color for the surrounding mines"
	^ (aNumber between: 1 and: 8)
		ifTrue: [ numberColors at: aNumber ]
		ifFalse: [ Color black ]

]

{ #category : 'accessing' }
MineSweeperTheme >> name [ 
	^ name
]

{ #category : 'accessing' }
MineSweeperTheme >> name: aString [
	name := aString
]

{ #category : 'accessing' }
MineSweeperTheme >> numberColors [
	^ numberColors
]

{ #category : 'accessing' }
MineSweeperTheme >> numberColors: anArray [
	numberColors := anArray
]
