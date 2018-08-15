testing
testWriteConnectFrame
	| frame byteStream reference |
	frame := StampConnectFrame new.
	frame host: 'stomp.github.com'.
	byteStream := ByteArray new writeStream.
	frame writeOn: (StampMedium on: byteStream).
	reference := String streamContents: [ :stream |
		stream 
			<< 'CONNECT'; lf;
			<< 'accept-version:1.2'; lf;
			<< 'host:stomp.github.com'; lf;
			lf; 
			nextPut: 0 asCharacter ].
	self assert: byteStream contents equals: reference asByteArray