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