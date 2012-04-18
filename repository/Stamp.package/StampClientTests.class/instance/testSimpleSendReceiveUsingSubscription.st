testing
testSimpleSendReceiveUsingSubscription
	| client frame destination message subscription |
	client := StampClient new.
	client open.
	self assert: client isConnected.
	(frame := StampSendFrame new)
		destination: (destination := '/queue/helloworld'); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: frame.
	subscription := client newSubscriptionTo: destination.
	client write: subscription subscribeFrame.
	frame := client read.
	self assert: frame command = #MESSAGE.
	self assert: frame body = message.
	self assert: frame destination = destination.
	self assert: frame subscription = subscription id.
	self deny: frame messageId isNil.
	client write: subscription unsubscribeFrame.
	client close