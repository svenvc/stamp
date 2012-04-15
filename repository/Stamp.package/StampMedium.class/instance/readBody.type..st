reading
readBody: length type: contentType
	| mimeType |
	mimeType := contentType asZnMimeType.
	mimeType isBinary 
		ifTrue: [ ^ self readBodyBytes: length ].
	(mimeType charSet isNil or: [ mimeType charSet = 'utf-8' ])
		ifTrue: [ ^ self readBodyString: length ].
	self error: 'Unsupported char set'