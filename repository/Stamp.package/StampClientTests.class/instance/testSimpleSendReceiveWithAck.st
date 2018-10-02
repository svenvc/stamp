testing
testSimpleSendReceiveWithAck
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