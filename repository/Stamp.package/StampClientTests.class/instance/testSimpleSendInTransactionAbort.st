testing
testSimpleSendInTransactionAbort
	| client frame transactionId |
	client := self client.
	client open.
	self assert: client isConnected.
	transactionId := client nextId.
	client write: (StampBeginFrame transaction: transactionId).
	(frame := StampSendFrame new)
		destination: '/queue/helloworld'; 
		text: 'Hello World from Stamp, the Pharo STOMP client';
		transaction: transactionId.
	client write: frame.
	client write: (StampAbortFrame transaction: transactionId).
	client close.
	"There should be nothing in the queue now"