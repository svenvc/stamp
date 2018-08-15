writing
writeWithReceipt: outgoingFrame
	| receiptId |
	receiptId := self nextId.
	outgoingFrame receipt: receiptId.
	self write: outgoingFrame.
	self readSuchThat: [ :frame | 
		frame command = #RECEIPT and: [ frame receiptId = receiptId ] ]