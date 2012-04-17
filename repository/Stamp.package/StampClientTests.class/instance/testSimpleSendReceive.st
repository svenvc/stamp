testing
testSimpleSendReceive
	| client frame destination message subscriptionId |
	client := StampClient new.
	client open.
	self assert: client isConnected.
	(frame := StampSendFrame new)
		destination: (destination := '/queue/helloworld'); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: frame.
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
	self deny: frame messageId isNil.
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId.
	client write: frame.
	client close