"
I am StampTransaction, a helper object to manage STOMP 1.2 transactions.
"
Class {
	#name : #StampTransaction,
	#superclass : #Object,
	#instVars : [
		'beginFrame'
	],
	#category : 'Stamp-Client'
}

{ #category : #accessing }
StampTransaction >> abortFrame [
	^ StampAbortFrame new
		transaction: self id;
		yourself
]

{ #category : #accessing }
StampTransaction >> beginFrame [
	^ beginFrame ifNil: [
		beginFrame := StampBeginFrame new ]
]

{ #category : #accessing }
StampTransaction >> commitFrame [
	^ StampCommitFrame new
		transaction: self id;
		yourself
]

{ #category : #accessing }
StampTransaction >> id [
	^ self beginFrame transaction
]

{ #category : #accessing }
StampTransaction >> id: string [
	^ self beginFrame transaction: string
]

{ #category : #convenience }
StampTransaction >> wrap: frame [
	frame transaction: self id.
	^ frame
]
