testing
testSimpleSendUsingTransactionAbort
	| client frame destination message transaction |
	client := StampClient new.
	client open.
	self assert: client isConnected.
	transaction := client newTransaction.
	client writeWithReceipt: transaction beginFrame.
	(frame := client newSendFrameTo: (destination := '/queue/helloworld'))
		text: (message := 'Hello World from Stamp, the Pharo STOMP client').
	client write: (transaction wrap: frame).	"Apparently no receipts are delivered until commit"
	client writeWithReceipt: transaction abortFrame.
	client close.
	"There should be nothing in the queue now"