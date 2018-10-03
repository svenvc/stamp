"
I am TStampFrameWithBody.
I am a Trait.
I group behavior for STOMP frames that have an optional body.

I assume that my users implement #body and #body: and are subclasses of StampFrame. 
"
Trait {
	#name : #TStampFrameWithBody,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
TStampFrameWithBody >> bytes: byteArray [
	self
		contentType: 'application/octet-stream';
		body: byteArray
]

{ #category : #accessing }
TStampFrameWithBody >> contentLength [
	^ (self headerAt: #'content-length' ifAbsent: [ nil ])
		ifNotNil: [ :value | value asInteger ]
]

{ #category : #accessing }
TStampFrameWithBody >> contentLength: length [
	self headerAt: #'content-length' put: length asString
]

{ #category : #accessing }
TStampFrameWithBody >> contentType [
	^ self headerAt: #'content-type'
]

{ #category : #accessing }
TStampFrameWithBody >> contentType: contentType [
	self headerAt: #'content-type' put: contentType
]

{ #category : #testing }
TStampFrameWithBody >> hasBody [
	^ self body notNil
]

{ #category : #reading }
TStampFrameWithBody >> readBodyFrom: stampMedium [
	self body: (stampMedium 
		readBody: self contentLength 
		type: self contentType)
]

{ #category : #accessing }
TStampFrameWithBody >> text: string [
	self
		contentType: 'text/plain';
		body: string
]

{ #category : #writing }
TStampFrameWithBody >> writeOn: stampMedium [
	self hasBody
		ifTrue: [ 
			self body isString
				ifTrue: [ self contentLength: (stampMedium encodedLengthOf: self body) ]
				ifFalse: [ self contentLength: self body size ] ].
	super writeOn: stampMedium
]
