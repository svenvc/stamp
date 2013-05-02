testing
testSimpleSendUsingTransactionAbort
	| client frame transaction |
	client := self client.
	client open.
	self assert: client isConnected.
	transaction := client newTransaction.
	client writeWithReceipt: transaction beginFrame.
	(frame := client newSendFrameTo: '/queue/helloworld')
		text: 'Hello World from Stamp, the Pharo STOMP client'.
	client write: (transaction wrap: frame).	"Apparently no receipts are delivered until commit"
	client writeWithReceipt: transaction abortFrame.
	client close.
	"There should be nothing in the queue now"