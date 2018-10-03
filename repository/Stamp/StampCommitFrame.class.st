"
I am StampCommitFrame
I am a StampClientFrame.
I implement STOMP COMMIT.

Sent to commit a transaction.

"
Class {
	#name : #StampCommitFrame,
	#superclass : #StampClientFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampCommitFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #COMMIT
]

{ #category : #'as yet unclassified' }
StampCommitFrame class >> transaction: id [
	^ self new
		transaction: id;
		yourself
]

{ #category : #accessing }
StampCommitFrame >> transaction [
	^ self headerAt: #transaction
]

{ #category : #accessing }
StampCommitFrame >> transaction: string [
	self headerAt: #transaction put: string
]
