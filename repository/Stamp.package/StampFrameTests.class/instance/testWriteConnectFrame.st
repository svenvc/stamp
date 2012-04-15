testing
testWriteConnectFrame
	| frame byteStream reference |
	frame := StampConnectFrame new.
	frame host: 'stomp.github.com'.
	byteStream := ByteArray new writeStream.
	frame writeOn: (StampMedium on: byteStream).
	reference := String streamContents: [ :stream |
		stream 
			nextPutAll: 'CONNECT'; lf;
			nextPutAll: 'accept-version:1.1'; lf;
			nextPutAll: 'host:stomp.github.com'; lf;
			lf; nextPut: (Character value: 0) ].
	self assert: byteStream contents = reference asByteArray