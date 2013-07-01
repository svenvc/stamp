testing
testError
	| client frame |
	client := self client.
	client open.
	self assert: client isConnected.
	"Provoke an error (Error frames should not be sent from clients to servers)."
	frame := StampErrorFrame new.
	client write: frame.
	self should: [ frame := client read ] raise: StampError.
	client close