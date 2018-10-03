"
I am StampAbortFrame.
I am a StampClientFrame.
I implement STOMP ABORT.

Sent to abort a transaction.
"
Class {
	#name : #StampAbortFrame,
	#superclass : #StampClientFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampAbortFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #ABORT
]

{ #category : #'instance creation' }
StampAbortFrame class >> transaction: id [
	^ self new
		transaction: id;
		yourself
]

{ #category : #accessing }
StampAbortFrame >> transaction [
	^ self headerAt: #transaction
]

{ #category : #accessing }
StampAbortFrame >> transaction: string [
	self headerAt: #transaction put: string
]
