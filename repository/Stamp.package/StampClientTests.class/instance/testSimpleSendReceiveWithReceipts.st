testing
testSimpleSendReceiveWithReceipts
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