"
I am StampFrameWrittenEvent, a StampLogEvent emitted when a StampFrame is written.
"
Class {
	#name : #StampFrameWrittenEvent,
	#superclass : #StampLogEvent,
	#instVars : [
		'frame'
	],
	#category : 'Stamp-Logging'
}

{ #category : #accessing }
StampFrameWrittenEvent >> frame [
	^ frame
]

{ #category : #accessing }
StampFrameWrittenEvent >> frame: anObject [
	frame := anObject
]

{ #category : #printing }
StampFrameWrittenEvent >> printContentsOn: stream [
	stream << 'Wrote '; print: frame
]
