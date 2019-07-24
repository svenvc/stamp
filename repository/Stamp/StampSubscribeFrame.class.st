"
I am StampSubscribeFrame
I am a StampClientFrame.
I implement STOMP SUBSCRIBE.

Sent to subscribe to a message stream.
"
Class {
	#name : #StampSubscribeFrame,
	#superclass : #StampClientFrame,
	#category : #'Stamp-Core'
}

{ #category : #accessing }
StampSubscribeFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #SUBSCRIBE
]

{ #category : #accessing }
StampSubscribeFrame >> ack [
	"See #autoAck, #clientAck and #clientIndividualAck"

	^ self headerAt: #ack ifAbsent: [ #auto ]
]

{ #category : #accessing }
StampSubscribeFrame >> ack: string [
	<doc: 'See #autoAck, #clientAck and #clientIndividualAck'>
	self assert: (#(#auto #client #'client-individual') includes: string).
	self headerAt: #ack put: string
]

{ #category : #accessing }
StampSubscribeFrame >> autoAck [
	<doc:
		'When the ack mode is auto, then the client does not need to send the server ACK frames for the messages it receives. The server will assume the client has received the message as soon as it sends it to the client. This acknowledgment mode can cause messages being transmitted to the client to get dropped. This is the default.'>
	
	self ack: #auto
]

{ #category : #accessing }
StampSubscribeFrame >> clientAck [
	<doc:
		'When the ack mode is client, then the client MUST send the server ACK frames for the messages it processes. If the connection fails before a client sends an ACK frame for the message the server will assume the message has not been processed and MAY redeliver the message to another client. The ACK frames sent by the client will be treated as a cumulative acknowledgment. This means the acknowledgment operates on the message specified in the ACK frame and all messages sent to the subscription before the ACK''ed message. In case the client did not process some messages, it SHOULD send NACK frames to tell the server it did not consume these messages.'>
	
	self ack: #client
]

{ #category : #accessing }
StampSubscribeFrame >> clientIndividualAck [
	<doc:
		'When the ack mode is client-individual, the acknowledgment operates just like the client acknowledgment mode except that the ACK or NACK frames sent by the client are not cumulative. This means that an ACK or NACK frame for a subsequent message MUST NOT cause a previous message to get acknowledged.'>
	self ack: #'client-individual'
]

{ #category : #accessing }
StampSubscribeFrame >> destination [
	^ self headerAt: #destination
]

{ #category : #accessing }
StampSubscribeFrame >> destination: string [
	self headerAt: #destination put: string
]

{ #category : #accessing }
StampSubscribeFrame >> id [
	^ self headerAt: #id
]

{ #category : #accessing }
StampSubscribeFrame >> id: string [
	self headerAt: #id put: string
]

{ #category : #accessing }
StampSubscribeFrame >> persistent [
	"See #persisten:"
	
	^ (self headerAt: #persistent ifAbsent: [ #false ]) = #true
]

{ #category : #accessing }
StampSubscribeFrame >> persistent: boolean [
	<doc:
		'This is a RabbitMQ extension. The STOMP adapter supports durable topic subscriptions. Durable subscriptions allow clients to disconnect from and reconnect to the STOMP broker as needed, without missing messages that are sent to the topic. Topics are neither durable nor transient, instead subscriptions are durable or transient. Durable and transient can be mixed against a given topic. To create a durable subscription, set the persistent header to true in the SUBSCRIBE frame. When creating a durable subscription, the id header must be specified.'>
	self headerAt: #persistent put: boolean printString
]

{ #category : #accessing }
StampSubscribeFrame >> prefetchCount [
	"See #persistent:"
	
	^ self headerAt: #'prefetch-count'
]

{ #category : #accessing }
StampSubscribeFrame >> prefetchCount: integer [
	<doc:
		'This is a RabbitMQ extension. The prefetch count for all subscriptions is set to unlimited by default. This can be controlled by setting the prefetch-count header on SUBSCRIBE frames to the desired integer count.'>
	self headerAt: #'prefetch-count' put: integer asString
]
