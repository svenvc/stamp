private
decodeValue: string
	^ (string includes: $\)
		ifFalse: [ string ]
		ifTrue: [ self unescapeString: string ]