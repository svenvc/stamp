"
I am StampTransaction, a helper object to manage STOMP 1.2 transactions.
"
Class {
	#name : #StampTransaction,
	#superclass : #Object,
	#instVars : [
		'beginFrame'
	],
	#category : #'Stamp-Client'
}

{ #category : #accessing }
StampTransaction >> abortFrame [
	<doc:'Creates an abortion frame for this transaction helper '>
	^ StampAbortFrame new
		transaction: self id;
		yourself
]

{ #category : #accessing }
StampTransaction >> beginFrame [
	<doc:'Gets the begin frame for this transaction helper '>
	^ beginFrame ifNil: [
		beginFrame := StampBeginFrame new ]
]

{ #category : #accessing }
StampTransaction >> commitFrame [
	<doc: 'Creates an commit frame for this transaction helper '>
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
	<doc:'Wraps a frame by setting a transaction id from this helper. Meaning that the frame will be treated as belonging to this transaction '>
	frame transaction: self id.
	^ frame
]
