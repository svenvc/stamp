"
I am StampDisconnectFrame.
I am a StampClientFrame.
I implement STOMP DISCONNECT.

Sent to release a connection to a host.
"
Class {
	#name : #StampDisconnectFrame,
	#superclass : #StampClientFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampDisconnectFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #DISCONNECT
]
