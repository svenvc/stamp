testing
testSimpleSendReceiveWithReceipts
	| client frame destination message receiptId subscriptionId |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := StampSendFrame new)
		destination: (destination := '/queue/helloworld'); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client');
		receipt: (receiptId := client nextId).
	client write: frame.
	frame := client read.
	self assert: frame command = #RECEIPT.
	self assert: frame receiptId = receiptId. 
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		ack: #auto;
		receipt: (receiptId := client nextId).
	client write: frame.
	frame := client read.
	self assert: frame command = #RECEIPT.
	self assert: frame receiptId = receiptId. 
	frame := client read.
	self assert: frame command = #MESSAGE.
	self assert: frame body = message.
	self assert: frame destination = destination.
	self assert: frame subscription = subscriptionId.
	self deny: frame messageId isNil.
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId;
		receipt: (receiptId := client nextId).
	client write: frame.
	frame := client read.
	self assert: frame command = #RECEIPT.
	self assert: frame receiptId = receiptId. 
	client close