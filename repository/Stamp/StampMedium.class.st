"
I am StampMedium.
I represent a reliable transport on which STOMP message can be written and from which STOMP message can be read.

Currently, I hardcode an underlying (binary / socket) stream.
In the future, there could be different implementations of my protocol. 

"
Class {
	#name : #StampMedium,
	#superclass : #Object,
	#instVars : [
		'stream',
		'encoder',
		'charsToEscape',
		'stringStream'
	],
	#category : 'Stamp-Core'
}

{ #category : #'instance creation' }
StampMedium class >> on: stream [
	^ self new
		on: stream;
		yourself
]

{ #category : #'initialize-release' }
StampMedium >> close [
	stream ifNotNil: [ 
		stream close.
		stream := nil ]
]

{ #category : #private }
StampMedium >> decodeValue: string [
	^ (string includes: $\)
		ifFalse: [ string ]
		ifTrue: [ self unescapeString: string ]
]

{ #category : #writing }
StampMedium >> encodedLengthOf: string [
	^ encoder encodedByteCountForString: string
]

{ #category : #writing }
StampMedium >> endFrame [
	stream nextPut: 0
]

{ #category : #writing }
StampMedium >> endLine [
	stream nextPut: 10	"Character linefeed"
]

{ #category : #private }
StampMedium >> escapeFor: char [
	char = Character linefeed ifTrue: [ ^ 110 ].		"ASCII char n"
	char = $: ifTrue: [ ^ 58 ].		"ASCII char c"
	char = $\ ifTrue: [ ^ 92 ].		"ASCII char \"
	self error: 'Unrecognized escape'
]

{ #category : #writing }
StampMedium >> flush [
	stream flush
]

{ #category : #'initialize-release' }
StampMedium >> initialize [
	super initialize.
	encoder := ZnUTF8Encoder new.
	charsToEscape := ByteString withAll: { Character linefeed. $:. $\ }.
]

{ #category : #testing }
StampMedium >> isConnected [
	^ stream notNil and: [ stream isConnected ]
]

{ #category : #writing }
StampMedium >> nextPutBytes: bytes [
	stream nextPutAll: bytes
]

{ #category : #writing }
StampMedium >> nextPutHeader: key value: value [
	self
		nextPutStringValueEncoded: key;
		nextPutString: ':';
		nextPutStringValueEncoded: value;
		endLine
]

{ #category : #writing }
StampMedium >> nextPutString: string [
	encoder next: string size putAll: string startingAt: 1 toStream: stream
]

{ #category : #writing }
StampMedium >> nextPutStringValueEncoded: string [
	string do: [ :each |
		(charsToEscape includes: each)
			ifTrue: [
				"Escape with a backslash \ (ASCII 92)"
				stream nextPut: 92; nextPut: (self escapeFor: each) ]
			ifFalse: [
				encoder nextPut: each toStream: stream ] ]
]

{ #category : #'initialize-release' }
StampMedium >> on: aSocketStream [
	stream := aSocketStream
]

{ #category : #reading }
StampMedium >> readBody: length type: contentType [
	| mimeType |
	mimeType := contentType asZnMimeType.
	mimeType isBinary 
		ifTrue: [ ^ self readBodyBytes: length ].
	(mimeType charSet isNil or: [ mimeType charSet = 'utf-8' ])
		ifTrue: [ ^ self readBodyString: length ].
	self error: 'Unsupported char set'
]

{ #category : #private }
StampMedium >> readBodyBytes: length [
	^ length 
		ifNil: [
			ByteArray streamContents: [ :out | | byte |
				[ stream atEnd or: [ (byte := stream next) = 0 ] ] whileFalse: [ 
					out nextPut: byte.
					stream position > StampConstants maxBodySize 
						ifTrue: [ self error: 'Body too large' ] ] ] ]
		ifNotNil: [ | buffer read |
			length <= StampConstants maxBodySize
				ifFalse: [ self error: 'Body too large' ].
			buffer := ByteArray new: length.
			read := stream readInto: buffer startingAt: 1 count: length.
			read = length ifFalse: [ self error: 'Incomplete body' ].
			self readEndFrame.
			buffer ]
			
]

{ #category : #private }
StampMedium >> readBodyString: length [
	| buffer totalRead read readStream bufferStream |
	readStream := length ifNotNil: [ ZnLimitedReadStream on: stream limit: length ] ifNil: [ stream ].
	buffer := String new: (ZnUtils streamingBufferSize min: (length ifNil: [ ZnUtils streamingBufferSize ])).
	bufferStream := nil.
	totalRead := 0.
	[ readStream atEnd ] whileFalse: [
		[ read := encoder readInto: buffer startingAt: 1 count: buffer size fromStream: readStream ]
			on: ZnByteStringBecameWideString 
			do: [ :notification | 
					buffer := notification wideString.
					bufferStream ifNotNil: [ | wideString position |
						position := bufferStream position.
						wideString := WideString from: bufferStream originalContents.
						bufferStream on: wideString; setFrom: position + 1 to: position ].
					notification resume ].
		totalRead := totalRead + read.
		totalRead > StampConstants maxBodySize
			ifTrue: [ self error: 'Body too large' ].
		bufferStream ifNil: [ 
			readStream atEnd
				ifTrue: [ self readEndFrame. ^ buffer copyFrom: 1 to: read ]
				ifFalse: [ bufferStream := (length ifNil: [ buffer species new ] ifNotNil: [ buffer species new: length ]) writeStream ] ].
		bufferStream next: read putAll: buffer startingAt: 1 ].
	self readEndFrame.
	^ bufferStream ifNil: [ String new ] ifNotNil: [ bufferStream contents ]
]

{ #category : #reading }
StampMedium >> readEndFrame [
	stream next = 0 ifFalse: [ self error: 'End of frame missing' ].
	
]

{ #category : #reading }
StampMedium >> readHeader [
	| line |
	^ (line := self readLine) isEmpty
		ifTrue: [ nil ]
		ifFalse: [ | index key value |
			index := line indexOf: $: .
			index = 0
				ifTrue: [ self error: 'Incorrect header, no colon found' ].
			key := self decodeValue: (line copyFrom: 1 to: index - 1).
			value := self decodeValue: (line copyFrom: index + 1 to: line size).
			key -> value ]
]

{ #category : #reading }
StampMedium >> readLine [
	^ self stringStreamContents: [ :out | | endOfLine |
		endOfLine := false.
		[ stream atEnd or: [ endOfLine ] ] whileFalse: [ | char |
			out position >= StampConstants maxHeaderLineLength
				ifTrue: [ self error: 'Line too long' ]. 
			char := encoder nextFromStream: stream.
			char = Character cr
				ifFalse: [ 
					char = Character lf
						ifTrue: [ endOfLine := true ]
						ifFalse: [ out nextPut: char ] ] ] ]
]

{ #category : #private }
StampMedium >> stringStreamContents: block [
	"Like String streamContents: block
	but reusing the underlying buffer for improved efficiency"
	
	stringStream 
		ifNil: [ 
			stringStream := (String new: 32) writeStream ].
	stringStream reset.
	block value: stringStream.
	^ stringStream contents
]

{ #category : #private }
StampMedium >> unescape: char [
	char = $n ifTrue: [ ^ Character linefeed ].
	char = $c ifTrue: [ ^ $: ].
	char = $\ ifTrue: [ ^ char ].
	self error: 'Unrecognized escape'.
]

{ #category : #private }
StampMedium >> unescapeString: string [
	| in |
	in := string readStream.
	^ String new: string size streamContents: [ :out |
		[ in atEnd ] whileFalse: [ | char |
			(char := in next) = $\
				ifTrue: [ out nextPut: (self unescape: in next) ]
				ifFalse: [ out nextPut: char ] ] ]
]
