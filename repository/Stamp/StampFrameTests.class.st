"
I am StampFrameTests.

"
Class {
	#name : #StampFrameTests,
	#superclass : #TestCase,
	#category : 'Stamp-Tests'
}

{ #category : #testing }
StampFrameTests >> testReadConnectedFrame [
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
]

{ #category : #testing }
StampFrameTests >> testReadEmptyFrame [
	| frame |
	frame := StampFrame readFrom: (StampMedium on: #[ 10 ] readStream).
	self assert: frame = StampEmptyFrame new.
	self assert: frame command isEmpty
]

{ #category : #testing }
StampFrameTests >> testReadErrorFrame [
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
]

{ #category : #testing }
StampFrameTests >> testReadErrorNoContentFrame [
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
]

{ #category : #testing }
StampFrameTests >> testWriteConnectFrame [
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
]

{ #category : #testing }
StampFrameTests >> testWriteSendFrame [
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
]
