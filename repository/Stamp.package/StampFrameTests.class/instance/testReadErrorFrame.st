testing
testReadErrorFrame
	| string frame |
	string := String streamContents: [ :stream |
		stream 
			<< 'ERROR'; lf;
			<< 'message:Bad command'; lf;
			<< 'content-type:text/plain'; lf;
			<< 'content-length:34'; lf;
			lf;
			<< 'Could not interpret command "FOO"'; lf;
			nextPut: 0 asCharacter ].
	frame := StampFrame readFrom: (StampMedium on: string asByteArray readStream).
	self assert: frame command = #ERROR.
	self assert: frame contentType = 'text/plain'.
	self assert: frame contentLength = 34.
	self assert: frame message = 'Bad command'.
	self deny: frame body isEmpty.
	self assert: frame body = ('Could not interpret command "FOO"', Character lf asString)