writing
encodedLengthOf: string
	^ string 
		inject: 0 
		into: [ :sum :each | sum + (encoder encodedByteCountFor: each) ]