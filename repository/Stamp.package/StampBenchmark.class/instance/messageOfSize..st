accessing
messageOfSize: size
	^ message
		ifNil: [ 
			message := binary
				ifTrue: [ self randomBytes: size ]
				ifFalse: [ self randomString: size ] ]