"
I am StampSubscription, a helper object to manage STOMP 1.2 subscriptions.

"
Class {
	#name : #StampSubscription,
	#superclass : #Object,
	#instVars : [
		'subscribeFrame'
	],
	#category : 'Stamp-Client'
}

{ #category : #accessing }
StampSubscription >> autoAck [
	self subscribeFrame autoAck
]

{ #category : #accessing }
StampSubscription >> clientAck [
	self subscribeFrame clientAck
]

{ #category : #accessing }
StampSubscription >> clientIndividualAck [
	self subscribeFrame clientIndividualAck
]

{ #category : #accessing }
StampSubscription >> destination [
	^ self subscribeFrame destination
]

{ #category : #accessing }
StampSubscription >> destination: string [
	self subscribeFrame destination: string
]

{ #category : #accessing }
StampSubscription >> id [
	^ self subscribeFrame id
]

{ #category : #accessing }
StampSubscription >> id: string [
	self subscribeFrame id: string
]

{ #category : #printing }
StampSubscription >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(.
	stream nextPut: $#; print: self id; space; << self destination; space; print: self subscribeFrame ack.
	stream nextPut: $)
]

{ #category : #accessing }
StampSubscription >> subscribeFrame [
	^ subscribeFrame 
		ifNil: [
			subscribeFrame := StampSubscribeFrame new ]
]

{ #category : #accessing }
StampSubscription >> unsubscribeFrame [
	^ StampUnsubscribeFrame new
		id: self id;
		yourself
]
