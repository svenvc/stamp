reading
readBody: length
	^ length 
		ifNil: [
			stream upTo: 0 ]
		ifNotNil: [ | buffer read |
			buffer := ByteArray new: length.
			read := stream readInto: buffer startingAt: 0 count: length.
			read = length ifFalse: [ self error: 'Incomplete body' ].
			self readEndFrame.
			buffer ]
			