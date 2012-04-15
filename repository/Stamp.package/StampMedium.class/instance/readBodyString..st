private
readBodyString: length
	| offset |
	offset := stream position.
	^ String new: length streamContents: [ :out |
		[ stream atEnd or: [ stream position - offset >= length ] ] whileFalse: [
			out nextPut: (encoder nextFromStream: stream) ].
		self readEndFrame ]
			