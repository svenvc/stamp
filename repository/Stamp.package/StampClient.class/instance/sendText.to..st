convenience
sendText: string to: destination
	| sendFrame |
	sendFrame := self newSendFrameTo: destination.
	sendFrame text: string.
	self write: sendFrame