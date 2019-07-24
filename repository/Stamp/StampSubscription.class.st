"
I am StampSubscription, a helper object to manage STOMP 1.2 subscriptions.

"
Class {
	#name : #StampSubscription,
	#superclass : #Object,
	#instVars : [
		'subscribeFrame'
	],
	#category : #'Stamp-Client'
}

{ #category : #accessing }
StampSubscription >> autoAck [
	<doc:'Sets the subscription AutoAck - All the received messages will be automatically deleted from the queue manager '>
	self subscribeFrame autoAck
]

{ #category : #accessing }
StampSubscription >> clientAck [
	<doc:'Sets the subscription ClientAck - All the received messages since the last read will be deleted from the queue manager as soon as an ack is communicated '>
	self subscribeFrame clientAck
]

{ #category : #accessing }
StampSubscription >> clientIndividualAck [
	<doc:'Sets the subscription clientIndividualAck - A  received message will be deleted from the queue manager as soon as it is acknowledged (individually) '>
	self subscribeFrame clientIndividualAck
]

{ #category : #accessing }
StampSubscription >> destination [
	^ self subscribeFrame destination
]

{ #category : #accessing }
StampSubscription >> destination: string [
	<doc: 'Sets the destination of the subscription '>
	self subscribeFrame destination: string
]

{ #category : #accessing }
StampSubscription >> id [
	^ self subscribeFrame id
]

{ #category : #accessing }
StampSubscription >> id: string [
	<doc:
		'Sets the id of  subscription. This ID must be used also for unsubscribing '>
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
	<doc:'Gets the subscribe frame being configured by this subscription helper. '>
	^ subscribeFrame 
		ifNil: [
			subscribeFrame := StampSubscribeFrame new ]
]

{ #category : #accessing }
StampSubscription >> unsubscribeFrame [
	<doc: 'It creates an Unsubscribe frame for this subcription helper'>
	^ StampUnsubscribeFrame new
		id: self id;
		yourself
]
