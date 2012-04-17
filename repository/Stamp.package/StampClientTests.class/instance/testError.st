testing
testError
	| client frame |
	client := StampClient new.
	client open.
	self assert: client isConnected.
	"Provoke an error (Error frames should not be sent from clients to servers)."
	frame := StampErrorFrame new.
	client write: frame.
	frame := client read.
	self assert: frame command = #ERROR.
	self assert: frame hasBody.
	self deny: frame message isNil.
	client close