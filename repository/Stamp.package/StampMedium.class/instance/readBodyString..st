private
readBodyString: length
	| byteCount |
	byteCount := length.
	^ String new: length streamContents: [ :out |
		[ stream atEnd or: [ byteCount <= 0 ] ] whileFalse: [ | char |
			out nextPut: (char := encoder nextFromStream: stream).
			byteCount := byteCount - (encoder encodedByteCountFor: char) ].
		self readEndFrame ]
			