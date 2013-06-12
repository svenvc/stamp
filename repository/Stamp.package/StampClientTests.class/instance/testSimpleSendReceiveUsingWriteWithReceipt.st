testing
testSimpleSendReceiveUsingWriteWithReceipt
	| client frame destination message subscriptionId |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := StampSendFrame new)
		destination: (destination := '/queue/helloworld'); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client writeWithReceipt: frame ifFail: [ self fail ].
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		ack: #auto.
	client writeWithReceipt: frame ifFail: [ self fail ].
	frame := client read.
	self assert: frame command = #MESSAGE.
	self assert: frame body = message.
	self assert: frame destination = destination.
	self assert: frame subscription = subscriptionId.
	self deny: frame messageId isNil.
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId.
	client writeWithReceipt: frame ifFail: [ self fail ].
	client close