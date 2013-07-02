testing
testSimpleSubscribeSendReceive
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
	self assert: frame command = #MESSAGE.
	self assert: frame body = message.
	self assert: frame destination = destination.
	self assert: frame subscription = subscriptionId.
	self deny: frame messageId isNil.
	(frame := StampUnsubscribeFrame new)
		id: subscriptionId.
	client write: frame.
	client close