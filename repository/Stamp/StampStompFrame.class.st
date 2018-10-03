"
I am StampStompFrame.
I am a StampClientFrame.
I implement STOMP STOMP.

Sent to initialize a new connection to a host.
"
Class {
	#name : #StampStompFrame,
	#superclass : #StampClientFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampStompFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #STOMP
]
