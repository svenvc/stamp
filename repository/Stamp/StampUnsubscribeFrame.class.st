"
I am StampUnsubscribeFrame
I am a StampClientFrame.
I implement STOMP UNSUBSCRIBE.

Sent to unsubscribe from a message stream.
"
Class {
	#name : #StampUnsubscribeFrame,
	#superclass : #StampClientFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampUnsubscribeFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #UNSUBSCRIBE
]

{ #category : #accessing }
StampUnsubscribeFrame >> destination [
	^ self headerAt: #destination
]

{ #category : #accessing }
StampUnsubscribeFrame >> destination: string [
	self headerAt: #destination put: string
]

{ #category : #accessing }
StampUnsubscribeFrame >> id [
	^ self headerAt: #id
]

{ #category : #accessing }
StampUnsubscribeFrame >> id: string [
	self headerAt: #id put: string
]
