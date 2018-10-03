"
I am StampAckFrame
I am a StampClientFrame.
I implement STOMP ACK.

Sent to acknowledge the reception of a message.
"
Class {
	#name : #StampAckFrame,
	#superclass : #StampClientFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampAckFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #ACK
]

{ #category : #accessing }
StampAckFrame >> id [
	^ self headerAt: #id
]

{ #category : #accessing }
StampAckFrame >> id: string [
	self headerAt: #id put: string
]

{ #category : #accessing }
StampAckFrame >> subscription [
	^ self headerAt: #subscription
]

{ #category : #accessing }
StampAckFrame >> subscription: string [
	self headerAt: #subscription put: string
]

{ #category : #accessing }
StampAckFrame >> transaction [
	^ self headerAt: #transaction
]

{ #category : #accessing }
StampAckFrame >> transaction: string [
	self headerAt: #transaction put: string
]
