"
I am StampFrameReadEvent, a StampLogEvent emitted when a StampFrame is read.
"
Class {
	#name : #StampFrameReadEvent,
	#superclass : #StampLogEvent,
	#instVars : [
		'frame'
	],
	#category : 'Stamp-Logging'
}

{ #category : #accessing }
StampFrameReadEvent >> frame [
	^ frame
]

{ #category : #accessing }
StampFrameReadEvent >> frame: anObject [
	frame := anObject
]

{ #category : #printing }
StampFrameReadEvent >> printContentsOn: stream [
	stream << 'Read '; print: frame
]
