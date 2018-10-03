"
I am StampErrorFrame.
I am a StampClientFrame.
I implement STOMP ERROR.

Sent when an error occurs.
"
Class {
	#name : #StampErrorFrame,
	#superclass : #StampServerFrame,
	#traits : 'TStampFrameWithBody',
	#classTraits : 'TStampFrameWithBody classTrait',
	#instVars : [
		'body'
	],
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampErrorFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #ERROR
]

{ #category : #accessing }
StampErrorFrame >> body [
	^ body
]

{ #category : #'as yet unclassified' }
StampErrorFrame >> body: object [
	body := object
]

{ #category : #accessing }
StampErrorFrame >> contentType [
	".. Otherwise, the receiver SHOULD consider the body to be a binary blob"
	^ self headerAt: #'content-type' ifAbsent: [ 'application/octet-stream' ]
]

{ #category : #accessing }
StampErrorFrame >> message [
	^ self headerAt: #message
]

{ #category : #accessing }
StampErrorFrame >> message: string [
	self headerAt: #message put: string
]
