testing
testReadConnectedFrame
	| frame string |
	string := String streamContents: [ :stream |
		stream 
			nextPutAll: 'CONNECTED'; lf;
			nextPutAll: 'version:1.1'; lf;
			nextPutAll: 'session:X1234'; lf;
			nextPutAll: 'server:test/1.0'; lf;
			lf; nextPut: (Character value: 0) ].
	frame := StampFrame readFrom: (StampMedium on: string asByteArray readStream).
	self assert: frame command = #CONNECTED.
	self assert: frame version = '1.1'.
	self assert: frame session = 'X1234'.
	self assert: frame server = 'test/1.0'