testing
testSimpleSendReceiveCombined
	| client frame destination message subscription |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := client newSendFrameTo: (destination := '/queue/helloworld'))
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client writeWithReceipt: frame.
	subscription := client newSubscriptionTo: destination.
	subscription clientIndividualAck.
	client writeWithReceipt: subscription subscribeFrame.
	frame := client read.
	self assert: frame command = #MESSAGE.
	self assert: frame body = message.
	self assert: frame destination = destination.
	self assert: frame subscription = subscription id.
	self deny: frame messageId isNil.
	client writeWithReceipt: frame ackFrame.
	client writeWithReceipt: subscription unsubscribeFrame.
	client close