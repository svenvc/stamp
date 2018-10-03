"
I am StampConnectedFrame.
I am a StampClientFrame.
I implement STOMP CONNECTED.

Sent to confirm initialization of a new connection.
"
Class {
	#name : #StampConnectedFrame,
	#superclass : #StampServerFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampConnectedFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #CONNECTED
]

{ #category : #accessing }
StampConnectedFrame >> heartbeat [
	^ ($, split: (self headerAt: #'heart-beat' ifAbsent: [ '0,0' ])) 
			collect: [ :each | each trimBoth asInteger ]
]

{ #category : #accessing }
StampConnectedFrame >> server [
	^ self headerAt: #server
]

{ #category : #accessing }
StampConnectedFrame >> session [
	^ self headerAt: #session
]

{ #category : #accessing }
StampConnectedFrame >> version [
	^ self headerAt: #version
]
