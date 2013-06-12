accessing
writeCount: count ofSize: size
	| client message frame filler |
	filler := self randomString: size.
	client := self client.
	^ [ 
	client open.
	1 to: count do: [ :each | 
		message := 'message-{1} {2}' format: {each asString. filler}.
		(frame := client newSendFrameTo: self queue)
			text: message.
		client write: frame ].
	count ] ensure: [ client close ]