testing
testSimpleSendReceive
	| client frame message subscriptionId |
	client := StampClient new.
	client open.
	self assert: client isConnected.
	frame := StampSendFrame new.
	frame
		destination: '/queue/helloworld'; 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: frame.
	frame := StampSubscribeFrame new.
	frame
		destination: '/queue/helloworld';
		id: (subscriptionId := client nextId);
		ack: #auto.
	client write: frame.
	frame := client read.
	self assert: frame command = #MESSAGE.
	self assert: frame body = message.
	frame := StampUnsubscribeFrame new.
	frame id: subscriptionId.
	client write: frame.
	client close