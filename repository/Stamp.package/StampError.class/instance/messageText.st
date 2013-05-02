accessing
messageText
	messageText ifNotNil: [ ^ messageText ].
	[ messageText := errorFrame message ] on: Error do: [ ^ String new ].
	^ messageText