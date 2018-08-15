testing
testErrorWithReceipt
	| client |
	client := self client.
	client open.
	self assert: client isConnected.
	"Provoke an error (cannot unsubscribe when there is no subscription)."
	self should: [ client writeWithReceipt: StampUnsubscribeFrame new ] raise: StampError.
	client close