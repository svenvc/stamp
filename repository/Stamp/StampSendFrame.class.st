"
I am StampSendFrame
I am a StampClientFrame.
I implement STOMP SEND.

Sent to deliver a message from the client to the server.

"
Class {
	#name : #StampSendFrame,
	#superclass : #StampClientFrame,
	#traits : 'TStampFrameWithBody',
	#classTraits : 'TStampFrameWithBody classTrait',
	#instVars : [
		'body'
	],
	#category : #'Stamp-Core'
}

{ #category : #accessing }
StampSendFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #SEND
]

{ #category : #accessing }
StampSendFrame >> body [
	^ body
]

{ #category : #accessing }
StampSendFrame >> body: object [
	body := object
]

{ #category : #accessing }
StampSendFrame >> destination [
	^ self headerAt: #destination
]

{ #category : #accessing }
StampSendFrame >> destination: string [
	self headerAt: #destination put: string
]

{ #category : #accessing }
StampSendFrame >> persistent [
	"See #persistent:"
	
	^ (self headerAt: #persistent ifAbsent: [ #false ]) = #true
]

{ #category : #accessing }
StampSendFrame >> persistent: boolean [
	<doc:
		'This is a RabbitMQ extension. Setting the persistent header to true has the effect of making the message persistent. Receipts for SEND frames with persistent:true are not sent until a confirm is received from the broker. MESSAGE frames for persistent messages will contain a persistent:true header.'>
	
	self headerAt: #persistent put: boolean printString
]

{ #category : #accessing }
StampSendFrame >> replyTo [
	"See #replyTo:"
	
	^ self headerAt: #'reply-to'
]

{ #category : #accessing }
StampSendFrame >> replyTo: string [
	<doc:
		'This is a RabbitMQ extension. Temp queue destinations allow you to define temporary destinations in the reply-to header of a SEND frame. Temp queues are managed by the broker and their identities are private to each session -- there is no need to choose distinct names for temporary queues in distinct sessions. To use a temp queue, put the reply-to header on a SEND frame and use a header value starting with /temp-queue/. A temporary queue is created (with a generated name) that is private to the session and automatically subscribes to that queue. A different session that uses reply-to:/temp-queue/foo will have a new, distinct queue created. The internal subscription id is a concatenation of the string /temp-queue/ and the temporary queue (so /temp-queue/foo in this example). The subscription id can be used to identify reply messages. Reply messages cannot be identified from the destination header, which will be different from the value in the reply-to header. The internal subscription uses auto-ack mode and it cannot be cancelled. The /temp-queue/ destination is not the name of the destination that the receiving client uses when sending the reply. Instead, the receiving client can obtain the (real) reply destination queue name from the reply-to header of the MESSAGE frame. This reply destination name can then be used as the value of the destination header in the SEND frame sent in reply to the received MESSAGE. Reply destination queue names are opaque and cannot be inferred from the /temp-queue/ name. SEND and SUBSCRIBE frames must not contain /temp-queue destinations in the destination header. Messages cannot be sent to /temp-queue destinations, and subscriptions to reply queues are created automatically.'>

	self headerAt: #'reply-to' put: string
]

{ #category : #accessing }
StampSendFrame >> transaction [
	^ self headerAt: #transaction
]

{ #category : #accessing }
StampSendFrame >> transaction: string [
	self headerAt: #transaction put: string
]
