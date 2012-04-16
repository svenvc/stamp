writing
writeOn: stampMedium
	self hasBody
		ifTrue: [ 
			self body isString
				ifTrue: [ self contentLength: (stampMedium encodedLengthOf: self body) ]
				ifFalse: [ self contentLength: self body size ] ].
	super writeOn: stampMedium