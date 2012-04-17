testing
testSimpleSendReceiveWithAck
	| client frame destination message ack subscriptionId |
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
		ack: #'client-individual'.
	client write: frame.
	frame := client read.
	self assert: frame command = #MESSAGE.
	self assert: frame body = message.
	self assert: frame destination = destination.
	self assert: frame subscription = subscriptionId.
	ack := frame ack.
	client write: ack. 
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId.
	client write: frame.
	client close