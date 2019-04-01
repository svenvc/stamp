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
					"It could be that the socket stream has an empty buffer, and a connected socket without available data yet.
			In such a state, the socket stream is not 'atEnd', and sending 'next' is expected to wait for available data. 
			BUT, on a ConnectionClosed, it could answer nil, ignoring the exception (see #fillReadBuffer).
			Trying to handle properly such case, by checking first if the socket stream is actually able to read a character.
			"
					stream peek
						ifNil: [ 
							stream isConnected ifFalse: [ 
								"Signal so that sender can act accordingly"
								ConnectionClosed signal: 'Connection close while reading StampMedium next line.'
								 ]
							 ]
						ifNotNil: [ char := encoder nextFromStream: stream.
							char = Character cr
								ifFalse: [ char = Character lf
										ifTrue: [ endOfLine := true ]
										ifFalse: [ out nextPut: char ] ] ] ] ]