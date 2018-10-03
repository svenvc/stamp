"
I am StampClientFrame.
I am a StampFrame.
I am the abstract superclass of all STOMP frames sent from a client to a server.

"
Class {
	#name : #StampClientFrame,
	#superclass : #StampFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampClientFrame >> receipt [
	^ self headerAt: #receipt
]

{ #category : #accessing }
StampClientFrame >> receipt: string [
	self headerAt: #receipt put: string
]

{ #category : #accessing }
StampClientFrame >> receiptFrame [
	^ StampReceiptFrame new
		receiptId: self receipt;
		yourself
]
