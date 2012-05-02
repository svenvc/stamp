testing
testSimpleSendUsingTransactionReceive
	| client frame destination message transaction subscription |
	client := StampClient new.
	client open.
	self assert: client isConnected.
	transaction := client newTransaction.
	client writeWithReceipt: transaction beginFrame.
	(frame := client newSendFrameTo: (destination := '/queue/helloworld'))
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: (transaction wrap: frame).	"Apparently no receipts are delivered until commit"
	client writeWithReceipt: transaction commitFrame.
	subscription := client newSubscriptionTo: destination.
	client writeWithReceipt: subscription subscribeFrame.
	frame := client read.
	self assert: frame command = #MESSAGE.
	self assert: frame body = message.
	self assert: frame destination = destination.
	self assert: frame subscription = subscription id.
	self assert: frame transaction = transaction id.
	self deny: frame messageId isNil.
	client write: subscription unsubscribeFrame.
	client close