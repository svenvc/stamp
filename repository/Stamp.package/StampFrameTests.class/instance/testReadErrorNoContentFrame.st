testing
testReadErrorNoContentFrame
	| string frame |
	string := String streamContents: [ :stream |
		stream
			<< 'ERROR'; lf;
			<< 'message:Stale connection. Missed heartbeat'; lf;
			lf;
			nextPut: 0 asCharacter ].
	frame := StampFrame readFrom: (StampMedium on: string asByteArray readStream).
	self assert: frame command equals: #ERROR.
	self assert: frame contentType equals: 'application/octet-stream'.
	self assert: frame contentLength equals: nil.
	self assert: frame message equals: 'Stale connection. Missed heartbeat'.
	self assert: frame body isEmpty.