writing
writeWithReceipt: outgoingFrame ifFail: block
	| receiptId incomingFrame |
	receiptId := self nextId.
	outgoingFrame receipt: receiptId.
	self write: outgoingFrame.
	incomingFrame := self read.
	"It is possible that we receive another frame..."
	(incomingFrame command = #RECEIPT and: [ incomingFrame receiptId = receiptId ])
		ifFalse: block