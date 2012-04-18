testing
testSimpleSendInTransactionAbort
	| client frame destination message transactionId |
	client := StampClient new.
	client open.
	self assert: client isConnected.
	transactionId := client nextId.
	client write: (StampBeginFrame transaction: transactionId).
	(frame := StampSendFrame new)
		destination: (destination := '/queue/helloworld'); 
		text: (message := 'Hello World from Stamp, the Pharo STOMP client');
		transaction: transactionId.
	client write: frame.
	client write: (StampAbortFrame transaction: transactionId).
	client close.
	"There should be nothing in the queue now"