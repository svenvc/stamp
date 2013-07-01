testing
testSimpleSendInTransactionReceive
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
		ack: #auto.
	client write: frame.
	frame := client read.
	self assert: frame command = #MESSAGE.
	self assert: frame body = message.
	self assert: frame destination = destination.
	self assert: frame subscription = subscriptionId.
	self assert: frame transaction = transactionId.
	self deny: frame messageId isNil.
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId.
	client write: frame.
	client close