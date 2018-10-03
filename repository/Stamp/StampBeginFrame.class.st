"
I am StampBeginFrame
I am a StampClientFrame.
I implement STOMP BEGIN.

Sent to start a new transaction.
"
Class {
	#name : #StampBeginFrame,
	#superclass : #StampClientFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampBeginFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #BEGIN
]

{ #category : #'instance creation' }
StampBeginFrame class >> transaction: id [
	^ self new
		transaction: id;
		yourself
]

{ #category : #accessing }
StampBeginFrame >> transaction [
	^ self headerAt: #transaction
]

{ #category : #accessing }
StampBeginFrame >> transaction: string [
	self headerAt: #transaction put: string
]
