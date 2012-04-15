testing
testWriteSendFrame
	| frame byteStream reference |
	frame := StampSendFrame new.
	frame destination: '/queue/a'.
	frame text: 'Hello World!'.
	byteStream := ByteArray new writeStream.
	frame writeOn: (StampMedium on: byteStream).
	reference := String streamContents: [ :stream |
		stream 
			<< 'SEND'; lf;
			<< 'destination:/queue/a'; lf;
			<< 'content-type:text/plain'; lf;
			<< 'content-length:12'; lf;
			lf; 
			<< 'Hello World!';
			nextPut: 0 asCharacter ].
	self assert: byteStream contents = reference asByteArray