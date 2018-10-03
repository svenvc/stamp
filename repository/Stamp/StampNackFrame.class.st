"
I am StampNackFrame
I am a StampClientFrame.
I implement STOMP NACK.

Sent to refuse the reception of a message.
"
Class {
	#name : #StampNackFrame,
	#superclass : #StampClientFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampNackFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #NACK
]

{ #category : #accessing }
StampNackFrame >> id [
	^ self headerAt: #id
]

{ #category : #accessing }
StampNackFrame >> id: string [
	self headerAt: #id put: string
]

{ #category : #accessing }
StampNackFrame >> subscription [
	^ self headerAt: #subscription
]

{ #category : #accessing }
StampNackFrame >> subscription: string [
	self headerAt: #subscription put: string
]

{ #category : #accessing }
StampNackFrame >> transaction [
	^ self headerAt: #transaction
]

{ #category : #accessing }
StampNackFrame >> transaction: string [
	self headerAt: #transaction put: string
]
