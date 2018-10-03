"
I am StampClientTests.

I assume a working STOMP 1.2 compatible server is running on localhost:61613

Tested against RabbitMQ 3.1, with default guest/guest and additional vhost localhost.
"
Class {
	#name : #StampClientTests,
	#superclass : #TestCase,
	#category : 'Stamp-Tests'
}

{ #category : #accessing }
StampClientTests >> client [
	| client |
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	"client debug: true."
	^ client
]

{ #category : #accessing }
StampClientTests >> helloWorldQueue [
	^ '/queue/helloworld'
]

{ #category : #testing }
StampClientTests >> testError [
	| client frame |
	client := self client.
	client open.
	self assert: client isConnected.
	"Provoke an error (Error frames should not be sent from clients to servers)."
	frame := StampErrorFrame new.
	client write: frame.
	self should: [ frame := client read ] raise: StampError.
	client close
]

{ #category : #testing }
StampClientTests >> testErrorWithReceipt [
	| client |
	client := self client.
	client open.
	self assert: client isConnected.
	"Provoke an error (cannot unsubscribe when there is no subscription)."
	self should: [ client writeWithReceipt: StampUnsubscribeFrame new ] raise: StampError.
	client close
]

{ #category : #testing }
StampClientTests >> testOpenClose [
	| client |
	client := self client.
	self deny: client isConnected.
	self assert: client session isNil.
	client open.
	self assert: client isConnected.
	self deny: client session isEmpty.
	client close.
	self deny: client isConnected.
	self assert: client session isNil
]

{ #category : #testing }
StampClientTests >> testSimpleRpc [
	| client server request response |
	"The server is a client listening on commands coming in on a queue named factorial"
	server := self client.
	[
		server open.
		server subscribeTo: 'factorial'.
		server runWith: [ :message | | number |
			message body = 'quit'
				ifTrue: [ ConnectionClosed signal ].
			number := message body asInteger.
			server sendText: number factorial asString to: message replyTo ] ] fork.
	client := self client.
	client open.
	10 to: 20 do: [ :each |
		request := client newSendFrameTo: 'factorial'.
		request text: each asString.
		request replyTo: '/temp-queue/factorial'.
		client write: request.
		"Wait up to standard timeout for a reply"
		response := client readMessage.
		self assert: response body equals: each factorial asString ].
	client sendText: 'quit' to: 'factorial'.
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleRpcCounter [
	| client server request response check |
	"The counter server listens to asynchroneous commands up, down and quit,
	as well as the synchroneous command value"
	server := self client.
	[ | counter |
		server open.
		counter := 0.
		server subscribeTo: 'counter'.
		server runWith: [ :message |
			message body = #quit
				ifTrue: [ ConnectionClosed signal ].
			message body = #up
				ifTrue: [ counter := counter + 1 ].
			message body = #down
				ifTrue: [ counter := counter - 1 ].
			message body = #value
				ifTrue: [ server sendText: counter asString to: message replyTo ] ] ] fork.
	client := self client.
	client open.
	"Helper to access the current counter value synchroneously"
	check := [ 
		request := client newSendFrameTo: 'counter'.
		request text: 'value'.
		request replyTo: '/temp-queue/counter'.
		client write: request.
		response := client readMessage.
		response body asNumber ].
	self assert: check value equals: 0.
	100 timesRepeat: [ 
		client sendText: 'up' to: 'counter' ].
	self assert: check value equals: 100.
	100 timesRepeat: [ 
		client sendText: 'down' to: 'counter' ].
	self assert: check value equals: 0.
	client sendText: 'quit' to: 'counter'.
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleSendInTransactionAbort [
	| client frame transactionId |
	client := self client.
	client open.
	self assert: client isConnected.
	transactionId := client nextId.
	client write: (StampBeginFrame transaction: transactionId).
	(frame := StampSendFrame new)
		destination: self helloWorldQueue; 
		text: 'Hello World from Stamp, the Pharo STOMP client';
		transaction: transactionId.
	client write: frame.
	client write: (StampAbortFrame transaction: transactionId).
	client close.
	"There should be nothing in the queue now"
]

{ #category : #testing }
StampClientTests >> testSimpleSendInTransactionReceive [
	| client frame destination message transactionId subscriptionId |
	client := self client.
	client open.
	self assert: client isConnected.
	transactionId := client nextId.
	client write: (StampBeginFrame transaction: transactionId).
	(frame := StampSendFrame new)
		destination: (destination := self helloWorldQueue); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client');
		transaction: transactionId.
	client write: frame.
	client write: (StampCommitFrame transaction: transactionId).
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		autoAck.
	client write: frame.
	frame := client read.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscriptionId.
	self assert: frame transaction equals: transactionId.
	self deny: frame messageId isNil.
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId.
	client write: frame.
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleSendReceive [
	| client frame destination message subscriptionId |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := StampSendFrame new)
		destination: (destination := self helloWorldQueue); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: frame.
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		autoAck.
	client write: frame.
	frame := client readMessage.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscriptionId.
	self deny: frame messageId isNil.
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId.
	client write: frame.
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleSendReceiveCombined [
	| client frame destination message subscription |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := client newSendFrameTo: (destination := self helloWorldQueue))
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client writeWithReceipt: frame.
	subscription := client newSubscriptionTo: destination.
	subscription clientIndividualAck.
	client writeWithReceipt: subscription subscribeFrame.
	frame := client readMessage.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscription id.
	self deny: frame messageId isNil.
	client writeWithReceipt: frame ackFrame.
	client writeWithReceipt: subscription unsubscribeFrame.
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleSendReceiveUsingSubscription [
	| client frame destination message subscription |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := StampSendFrame new)
		destination: (destination := self helloWorldQueue); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: frame.
	subscription := client newSubscriptionTo: destination.
	client write: subscription subscribeFrame.
	frame := client readMessage.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscription id.
	self deny: frame messageId isNil.
	client write: subscription unsubscribeFrame.
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleSendReceiveUsingWriteWithReceipt [
	| client frame destination message subscriptionId |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := StampSendFrame new)
		destination: (destination := self helloWorldQueue); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client writeWithReceipt: frame.
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		autoAck.
	client writeWithReceipt: frame.
	frame := client readMessage.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscriptionId.
	self deny: frame messageId isNil.
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId.
	client writeWithReceipt: frame.
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleSendReceiveWithAck [
	| client frame destination message ack subscriptionId |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := StampSendFrame new)
		destination: (destination := self helloWorldQueue); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: frame.
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		clientIndividualAck.
	client write: frame.
	frame := client readMessage.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscriptionId.
	ack := frame ackFrame.
	client write: ack. 
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId.
	client write: frame.
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleSendReceiveWithReceipts [
	| client frame destination message receiptId subscriptionId |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := StampSendFrame new)
		destination: (destination := self helloWorldQueue); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client');
		receipt: (receiptId := client nextId).
	client write: frame.
	frame := client read.
	self assert: frame command equals: #RECEIPT.
	self assert: frame receiptId equals: receiptId. 
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		autoAck;
		receipt: (receiptId := client nextId).
	client write: frame.
	frame := client read.
	self assert: frame command equals: #RECEIPT.
	self assert: frame receiptId equals: receiptId. 
	frame := client read.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscriptionId.
	self deny: frame messageId isNil.
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId;
		receipt: (receiptId := client nextId).
	client write: frame.
	frame := client read.
	self assert: frame command equals: #RECEIPT.
	self assert: frame receiptId equals: receiptId. 
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleSendUsingTransactionAbort [
	| client frame transaction |
	client := self client.
	client open.
	self assert: client isConnected.
	transaction := client newTransaction.
	client writeWithReceipt: transaction beginFrame.
	(frame := client newSendFrameTo: self helloWorldQueue)
		text: 'Hello World from Stamp, the Pharo STOMP client'.
	client write: (transaction wrap: frame).	"Apparently no receipts are delivered until commit"
	client writeWithReceipt: transaction abortFrame.
	client close.
	"There should be nothing in the queue now"
]

{ #category : #testing }
StampClientTests >> testSimpleSendUsingTransactionReceive [
	| client frame destination message transaction subscription |
	client := self client.
	client open.
	self assert: client isConnected.
	transaction := client newTransaction.
	client writeWithReceipt: transaction beginFrame.
	(frame := client newSendFrameTo: (destination := self helloWorldQueue))
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: (transaction wrap: frame).	"Apparently no receipts are delivered until commit"
	client writeWithReceipt: transaction commitFrame.
	subscription := client newSubscriptionTo: destination.
	client writeWithReceipt: subscription subscribeFrame.
	frame := client readMessage.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscription id.
	self assert: frame transaction equals: transaction id.
	self deny: frame messageId isNil.
	client write: subscription unsubscribeFrame.
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleSubscribeSendReceive [
	| client frame destination message subscriptionId |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := StampSubscribeFrame new)
		destination: (destination := self helloWorldQueue);
		id: (subscriptionId := client nextId);
		autoAck.
	client write: frame.
	(frame := StampSendFrame new)
		destination: destination; 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: frame.
	frame := client readMessage.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscriptionId.
	self deny: frame messageId isNil.
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId.
	client write: frame.
	client close
]

{ #category : #testing }
StampClientTests >> testSimpleWorkQueue [
	| processor1 processor2 client quit processed1 processed2 all |
	"Processor 1 & 2 listen for dummy work, waiting a number of milliseconds, failing on an odd or even count"
	quit := false.
	processed1 := SortedCollection new.
	processor1 := self client.
	processor1 open.
	[ | subscription |
		subscription := processor1 newSubscriptionTo: 'work'.
		subscription clientIndividualAck.
		processor1 write: subscription subscribeFrame.
		processor1 runWith: [ :message | | number |
			quit ifTrue: [ ConnectionClosed signal ].
			number := message body asInteger.
			(Delay forMilliseconds: number) wait.
			number even 
				ifTrue: [ 
					processed1 add: number. 
					processor1 write: message ackFrame ] 
				ifFalse: [ 
					processor1 write: message nackFrame ] ] ] fork.
	processed2 := SortedCollection new.
	processor2 := self client.
	processor2 open.
	[ | subscription |
		subscription := processor2 newSubscriptionTo: 'work'.
		subscription clientIndividualAck.
		processor2 write: subscription subscribeFrame .
		processor2 runWith: [ :message | | number |
			quit ifTrue: [ ConnectionClosed signal ].
			number := message body asInteger.
			(Delay forMilliseconds: number) wait.
			number odd
				ifTrue: [ 
					processed2 add: number.
					processor2 write: message ackFrame ] 
				ifFalse: [ 
					processor2 write: message nackFrame ] ] ] fork.
	all := SortedCollection new.
	client := self client.
	client open.
	100 timesRepeat: [ | number work |
		number := 10 atRandom .
		all add: number.
		work := client newSendFrameTo: 'work'.
		work text: number asString.
		client writeWithReceipt: work ].
	"wait at most 5 seconds"
	50 timesRepeat: [ 
		processed1 size + processed2 size >= 100 
			ifFalse: [ 0.1 second asDelay wait ] ].
	quit := true.
	client close.
	self assert: (processed1 allSatisfy: [ :each | each even ]).
	self assert: (processed2 allSatisfy: [ :each | each odd ]).
	self assert: processed1 , processed2 equals: all
]
