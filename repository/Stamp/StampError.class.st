"
I am StampError, an Error signaled when a StampErrorFrame is received.
"
Class {
	#name : #StampError,
	#superclass : #Error,
	#instVars : [
		'errorFrame'
	],
	#category : 'Stamp-Core'
}

{ #category : #signaling }
StampError class >> signalFor: errorFrame [
	^ self new
		errorFrame: errorFrame;
		signal
]

{ #category : #accessing }
StampError >> errorFrame [
	^ errorFrame
]

{ #category : #accessing }
StampError >> errorFrame: anObject [
	errorFrame := anObject
]

{ #category : #accessing }
StampError >> messageText [
	messageText ifNotNil: [ ^ messageText ].
	[ messageText := errorFrame message ] on: Error do: [ ^ String new ].
	^ messageText
]
