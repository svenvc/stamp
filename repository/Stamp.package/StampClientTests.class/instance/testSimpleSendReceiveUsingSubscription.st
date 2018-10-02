testing
testSimpleSendReceiveUsingSubscription
	| client frame destination message subscription |
	client := self client.
	client open.
	self assert: client isConnected.
	(frame := StampSendFrame new)
		destination: (destination := self helloWorldQueue); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: frame.
	subscription := client newSubscriptionTo: destination.
	client write: subscription subscribeFrame.
	frame := client readMessage.
	self assert: frame command equals: #MESSAGE.
	self assert: frame body equals: message.
	self assert: frame destination equals: destination.
	self assert: frame subscription equals: subscription id.
	self deny: frame messageId isNil.
	client write: subscription unsubscribeFrame.
	client close