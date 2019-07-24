"
Stamp is an implementation of STOMP (Simple (or Streaming) Text Oriented Message Protocol) for Pharo, a protocol to interact with message-oriented middleware (MOM).

More specifically, Stamp implements STOMP 1.2 and was tested against RabbitMQ 3.1. Other message-oriented middleware implementations accessible through STOMP include Apache ActiveMQ, Glassfish Open MQ and Fuse Message Broker based on Active MQ - but these have not yet been tested.

Messaging middleware is an important technology for building scaleable and flexible enterprise software architectures.



"
Class {
	#name : #ManifestOfStamp,
	#superclass : #PackageManifest,
	#category : #'Stamp-Client'
}

{ #category : #'1 Connect' }
ManifestOfStamp class >> exampleConnect [
	<example>
	| client |
	" Creates a client for interacting with a default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	^ client
	

]

{ #category : #'1 Connect' }
ManifestOfStamp class >> exampleConnectForDebug [
	<example>
	| client |
	" Creates a client for interacting with a default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Sets it into debug mode "
	client debug: true.
	" Open the client connection "
	client open.
	^ client
	

]

{ #category : #'5 Transaction' }
ManifestOfStamp class >> exampleOnTransactionAborted [
	<example>
	| client frame transaction |
	" 
This example targets to illustrate the usage of transactions, in the success case (Begin and commit).
This example is based on the test #testSimpleSendUsingTransactionReceive.
"
	"====== factorialService side ======
Creates a StampClient for the default RabbitMQ installation"

	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Creates a new trasnaction object. This object will help us to orchestrate a transaction "
	transaction := client newTransaction.
	" Write the beginFrame. This frame indicates the starting point of the transaction to the queuing system. 
It is recommended to ensure the reception of a receipt, that acknowledges the beginning of the transaction "
	client writeWithReceipt: transaction beginFrame.

	" After the begin of the transaction, we can send as much messages as we want, wrapping them into the transacion by using #wrap:"
	(frame := client newSendFrameTo: '/queue/helloworld')
		text: 'Hello World from Stamp, the Pharo STOMP client'.
	client write: (transaction wrap: frame).	"Apparently no receipts are delivered until commit"
	"Finally, for finishing the transaction, we shall write the abortFrame of the transaction, that indicates the end of the transaction.
It is recommended to ensure the reception of a receipt, that acknowledges the finishing of the transaction "
	client writeWithReceipt: transaction abortFrame.
	client close
]

{ #category : #'5 Transaction' }
ManifestOfStamp class >> exampleOnTransactionCommited [
	<example>
	| client frame  transaction  |
	
" 
This example targets to illustrate the usage of transactions, in the success case (Begin and commit).
This example is based on the test #testSimpleSendUsingTransactionReceive.
"
	"====== factorialService side ======

Creates a StampClient for the default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Creates a new trasnaction object. This object will help us to orchestrate a transaction "
	transaction := client newTransaction.
	" Write the beginFrame. This frame indicates the starting point of the transaction to the queuing system. 
It is recommended to ensure the reception of a receipt, that acknowledges the beginning of the transaction "
	client writeWithReceipt: transaction beginFrame.

	" After the begin of the transaction, we can send as much messages as we want, wrapping them into the transacion by using #wrap:"
	(frame := client newSendFrameTo: '/queue/helloworld')
		text: 'Hello World from Stamp, the Pharo STOMP client'.
	client write: (transaction wrap: frame).	"Apparently no receipts are delivered until commit"
	"Finally, for finishing the transaction, we shall write the commitFrame of the transaction, that indicates the end of the transaction.
It is recommended to ensure the reception of a receipt, that acknowledges the finishing of the transaction "

	client writeWithReceipt: transaction commitFrame.
	
	client close
]

{ #category : #'3 Read/Write' }
ManifestOfStamp class >> exampleReadSubscription [
	<example>
	| client frame |
	" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Subscribe our client to the queue 'test' "
	client subscribeTo: 'test'.
	" From now on we can read messages of this queue "
	frame := client readMessage.
	
	

	

]

{ #category : #'3 Read/Write' }
ManifestOfStamp class >> exampleReadSubscriptionLoop [
	<example>
	| client process |
	" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Subscribe our client to the queue 'test' "
	client subscribeTo: 'test'.
" Stamp provides a runWith: loop in the level of the client. 
#runWith: receives a block that receives one message as parameter.
This method executes a repeat loop, that only stop with the special exception ConnectionClosed.
This call is mean to be called inside a forking process. 
"
	process := [client runWith: [: m | ConnectionClosed signal ]] fork .
	

	process terminate.
	client close.
	
	

	

]

{ #category : #'3 Read/Write' }
ManifestOfStamp class >> exampleSendMessageToQueue [
	<example>
	| client frame |
	" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Sends a text message 'something' "
	client sendText: 'something' to: 'test'
]

{ #category : #'3 Read/Write' }
ManifestOfStamp class >> exampleSendMessageToQueueWithReply [
	<example>
	"This example illustrates the usage of #replyTo:. 
 1- 	#replyTo: must be invoked with a temp-queue. 
 2- The client will be bound to the private-ephemeral queue named, for receiving a response. 
For More information, see #StampSendFrame >> #replyTo: or address the RabbitMQ documentation 
	"
	| client frame |
	" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Sends a text message 'something' "
	frame := client newSendFrameTo: 'queue'.
	" It sets some text of the frame "
	frame text: 'some value'.
	" Sets up as replyTo queue /temp-queue/response "
	frame replyTo: '/temp-queue/response'.
	" Writes and flush the frame to the queue manager "
	client write: frame.
	" Wait up to standard timeout for a reply "
	client readMessage.
]

{ #category : #'4 Functional examples' }
ManifestOfStamp class >> exampleSimpleRpc [
	<example>
	| factorialConsumer factorialService request response |
" This example sets up a client named factorialService.
FactorialService is configured to consume numbers, and respond with the factorial of this received number. 

This example also sets up a client named factorialConsumer.
FactorialConsumer is configured to send numbers and log the factorial of the received result.

This example is based on the test testSimpleRpc. "

"====== factorialService side ======

Creates a StampClient for the default RabbitMQ installation"
	factorialService := StampClient new.
	factorialService login: 'guest'.
	factorialService passcode: 'guest'.
	
	[ 
" Open the connection "

	factorialService open.
" Subscribe to the queue factorial "
	factorialService subscribeTo: 'factorial'.

" Forks a #runWith: call. "

	factorialService
		runWith: [ :message | 
			| number |
" If the received message is quit, it stops the process by using the special exception #ConnectionClosed"
			message body = 'quit' ifTrue: [ 
				ConnectionClosed signal 
			].
" Otherwise, the message must by a number encoded as string "
			number := message body asInteger.
" Sends  the result of the calculation to the #replyTo queue "
			factorialService sendText: number factorial asString to: message replyTo 
		] ] fork.


"==== factorialConsumer side =====

Creates a StampClient for the default RabbitMQ installation "

	factorialConsumer := StampClient new.
	factorialConsumer login: 'guest'.
	factorialConsumer passcode: 'guest'.
	
" Open the connection "
	factorialConsumer open.
	10 to: 20 do: [ :each | 
" Creates a send frame targeting the queue #factorial "
		request := factorialConsumer newSendFrameTo: 'factorial'.
		
" It sets the each number asString in the text of the frame "
		request text: each asString.
		
" Sets up as replyTo queue /temp-queue/factorial "
		request replyTo: '/temp-queue/factorial'.
		
" Writes and flush the frame to the queue manager "
		factorialConsumer write: request.
		
" Wait up to standard timeout for a reply "
		response := factorialConsumer readMessage.
		
" Logs the response with the Transcript "
		Transcript logCr: response body.
		  
].

" Once the the loop is finished, it sends the #quit message to the factorial queue, allowing the process to finish "
	factorialConsumer sendText: 'quit' to: 'factorial'.
" Closes the factorialConsumer connection "
	factorialConsumer close
]

{ #category : #'4 Functional examples' }
ManifestOfStamp class >> exampleSimpleSendRecv [
	<example>
	| client frame destination subscriptionId |
	" Creates a client for interacting with a default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Create a send frame, and setup the destination and message "
	(frame := StampSendFrame new)
		destination: (destination := '/queue/helloworld');
		text: 'Hello World from Stamp, the Pharo STOMP client'.
	" Writes the message "
	client write: frame.

	" Create a subcsription frame, and setup the destination id "
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		autoAck.
	" Writes the subscription "
	client write: frame.
	" After subscribed it can read the messages from the same queue "
	frame := client readMessage.
	" Finally, it prepares an unsubscription frame "
	(frame := StampUnsubscribeFrame new) id: subscriptionId.
	" It writes the unsubscription  "
	client write: frame.
	" Finishes the connection "
	client close
]

{ #category : #'4 Functional examples' }
ManifestOfStamp class >> exampleSimpleSendRecvWithIndividualAck [
	<example>
	| client frame destination subscriptionId ack |
	" Creates a client for interacting with a default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Create a send frame, and setup the destination and message "
	(frame := StampSendFrame new)
		destination: (destination := '/queue/helloworld');
		text: 'Hello World from Stamp, the Pharo STOMP client'.
	" Writes the message "
	client write: frame.

	" Create a subcsription frame, and setup the destination id. We shall notice that the subscription is configured to be #clientIndividualAck"
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		clientIndividualAck.
	" Writes the subscription "
	client write: frame.
	" After subscribed it can read the messages from the same queue "
	frame := client readMessage.
	
	" Once we got the message, we have to manually ack the message. If not, it will not be removed from the queue manager.
For doing so, we have first to create an ack frame for the received message "
	ack := frame ackFrame.
	" And to write it down in the client to transmit it "
	client write: ack. 
	
	" Finally, it prepares an unsubscription frame "
	(frame := StampUnsubscribeFrame new) id: subscriptionId.
	" It writes the unsubscription  "
	client write: frame.
	" Finishes the connection "
	client close
]

{ #category : #'4 Functional examples' }
ManifestOfStamp class >> exampleSimpleSendRecvWithReceipt [
	<example>
	| client frame receiptId |
	"This example is based on the test testSimpleSendReceiveWithReceipts. 
This example illustrates how to use the #receipt feature. 
The receipt features serves to ensure the reception of a message to the queue. 

	"
	" Creates a client for interacting with a default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Create a send frame, and setup the destination and message. Note that the message has the extra confiration of #receipt:. The identifier passed will be used in the #RECEIPT message sent by the RabbitMQ "
	(frame := StampSendFrame new)
		destination: '/queue/helloworld';
		text: 'Hello World from Stamp, the Pharo STOMP client';
		receipt: (receiptId := client nextId).
	" Writes the message "
	client write: frame.

	" Note that in this example we use read instead of readMessage. Because the #RECEIPT frame is not a message . "
	frame := client read.

	" Some asserts to make the point  "
	self assert: frame command = #RECEIPT.
	self assert: frame receiptId = receiptId.

	" Finishes the connection "
	client close
]

{ #category : #'2 Subscription' }
ManifestOfStamp class >> exampleSubscribeToQueue [
	<example>
	| client |
	" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Subscribe our client to the queue 'test' "
	client subscribeTo: 'test'
]

{ #category : #'2 Subscription' }
ManifestOfStamp class >> exampleSubscribeToQueueForOneTaskAtTheTime [
	<example>
	| client subscription |
	" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
	" Create a subcription helper object pointing to a given queue "
	subscription := client newSubscriptionTo: 'queue'.
	"Set the prefetchCount to 1. 
This is a RabbitMQ extension. The prefetch count for all subscriptions is set to unlimited by default. This can be controlled by setting the prefetch-count header on SUBSCRIBE frames to the desired integer count.
	"
	subscription prefetchCount: 1. 
	"Writes the generated subscription frame, for starting listening on this queue "
	client write: subscription subscribeFrame.
	"Writes the generated unsubscription frame, for canceling the subscription on this queue "
	client write: subscription unsubscribeFrame.	
	client close.
]
