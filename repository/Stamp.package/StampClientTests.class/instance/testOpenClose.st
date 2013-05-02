testing
testOpenClose
	| client |
	client := self client.
	self deny: client isConnected.
	self assert: client session isNil.
	client open.
	self assert: client isConnected.
	self deny: client session isEmpty.
	client close.
	self deny: client isConnected.
	self assert: client session isNil