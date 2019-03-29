reading
readLine
	^ self
		stringStreamContents: [ :out | 
			| endOfLine |
			endOfLine := false.
			[ stream atEnd or: [ endOfLine ] ]
				whileFalse: [ | char |
					out position >= StampConstants maxHeaderLineLength
						ifTrue: [ self error: 'Line too long' ].
					"we first check that the socket stream is actually able to read a character.
			It could be that the socket stream has an empty buffer, but a connected socket without available data.
			In such a state, the socket stream will not be atEnd, but will still have nothing to read"
					stream peek
						ifNotNil: [ char := encoder nextFromStream: stream.
							char = Character cr
								ifFalse: [ char = Character lf
										ifTrue: [ endOfLine := true ]
										ifFalse: [ out nextPut: char ] ] ] ] ]