testing
testSimpleSendReceiveCombined
	| client frame destination message subscription |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := client newSendFrameTo: (destination := self helloWorldQueue))
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client writeWithReceipt: frame.
	subscription := client newSubscriptionTo: destination.
	subscription clientIndividualAck.
	client writeWithReceipt: subscription subscribeFrame.
	frame := client readMessage.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscription id.
	self deny: frame messageId isNil.
	client writeWithReceipt: frame ackFrame.
	client writeWithReceipt: subscription unsubscribeFrame.
	client close