private
readBodyBytes: length
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
			