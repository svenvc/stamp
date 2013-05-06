private
readBodyString: length
	| byteCount |
	^ length 
		ifNil: [
			byteCount := 0.
			String streamContents: [ :out |
				[ stream atEnd or: [ stream peek = 0 ] ] whileFalse: [ | char |
					out nextPut: (char := encoder nextFromStream: stream).
					byteCount := byteCount + (encoder encodedByteCountFor: char).
					byteCount > StampConstants maxBodySize
						ifTrue: [ self error: 'Body too large' ] ] ].
			self readEndFrame ]
		ifNotNil: [
			byteCount := length.
			String new: length streamContents: [ :out |
				[ stream atEnd or: [ byteCount <= 0 ] ] whileFalse: [ | char |
					out nextPut: (char := encoder nextFromStream: stream).
					byteCount := byteCount - (encoder encodedByteCountFor: char) ].
			self readEndFrame ] ]