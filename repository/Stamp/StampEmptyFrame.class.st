"
I am StampEmptyFrame.
I am a StampFrame.
I represent an empty STOMP frame as read from an empty line.
I have only one instance.
"
Class {
	#name : #StampEmptyFrame,
	#superclass : #StampFrame,
	#classVars : [
		'SingleInstance'
	],
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampEmptyFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ ''
]

{ #category : #'instance creation' }
StampEmptyFrame class >> new [
	^ SingleInstance ifNil: [ SingleInstance := super new ]
]

{ #category : #writing }
StampEmptyFrame >> writeOn: stampMedium [
	stampMedium endLine
]
