writing
nextPutStringValueEncoded: string
	string do: [ :each |
		(charsToEscape includes: each)
			ifTrue: [
				"Escape with a backslash \ (ASCII 92)"
				stream nextPut: 92; nextPut: (self escapeFor: each) ]
			ifFalse: [
				encoder nextPut: each toStream: stream ] ]