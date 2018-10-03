"
I am StampMessageFrame.
I am a StampClientFrame.
I implement STOMP MESSAGE.

Sent to deliver a message from the server to the client.
"
Class {
	#name : #StampMessageFrame,
	#superclass : #StampServerFrame,
	#traits : 'TStampFrameWithBody',
	#classTraits : 'TStampFrameWithBody classTrait',
	#instVars : [
		'body'
	],
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampMessageFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #MESSAGE
]

{ #category : #accessing }
StampMessageFrame >> ackFrame [
	^ StampAckFrame new
		id: self messageId;
		subscription: self subscription;
		yourself
]

{ #category : #accessing }
StampMessageFrame >> body [
	^ body
]

{ #category : #accessing }
StampMessageFrame >> body: object [
	body := object
]

{ #category : #accessing }
StampMessageFrame >> destination [
	^ self headerAt: #destination
]

{ #category : #accessing }
StampMessageFrame >> destination: string [
	self headerAt: #destination put: string
]

{ #category : #accessing }
StampMessageFrame >> messageId [
	^ self headerAt: #'message-id'
]

{ #category : #accessing }
StampMessageFrame >> messageId: string [
	self headerAt: #'message-id' put: string
]

{ #category : #accessing }
StampMessageFrame >> nackFrame [
	^ StampNackFrame new
		id: self messageId;
		subscription: self subscription;
		yourself
]

{ #category : #accessing }
StampMessageFrame >> persistent [
	^ (self headerAt: #persistent ifAbsent: [ #false ]) = #true
]

{ #category : #accessing }
StampMessageFrame >> persistent: boolean [
	self headerAt: #persistent put: boolean printString
]

{ #category : #accessing }
StampMessageFrame >> replyTo [
	^ self headerAt: #'reply-to'
]

{ #category : #accessing }
StampMessageFrame >> replyTo: string [
	self headerAt: #'reply-to' put: string
]

{ #category : #accessing }
StampMessageFrame >> subscription [
	^ self headerAt: #subscription
]

{ #category : #accessing }
StampMessageFrame >> subscription: string [
	self headerAt: #subscription put: string
]

{ #category : #accessing }
StampMessageFrame >> transaction [
	^ self headerAt: #transaction
]

{ #category : #accessing }
StampMessageFrame >> transaction: string [
	self headerAt: #transaction put: string
]
