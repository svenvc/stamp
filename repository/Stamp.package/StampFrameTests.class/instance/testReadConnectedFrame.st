testing
testReadConnectedFrame
	| frame string |
	string := String streamContents: [ :stream |
		stream 
			<< 'CONNECTED'; lf;
			<< 'version:1.1'; lf;
			<< 'session:X1234'; lf;
			<< 'server:test/1.0'; lf;
			lf; 
			nextPut: 0 asCharacter ].
	frame := StampFrame readFrom: (StampMedium on: string asByteArray readStream).
	self assert: frame command = #CONNECTED.
	self assert: frame version = '1.1'.
	self assert: frame session = 'X1234'.
	self assert: frame server = 'test/1.0'