reading
readLine
	^ String streamContents: [ :out | | endOfLine |
		endOfLine := false.
		[ stream atEnd or: [ endOfLine ] ] whileFalse: [ | char |
			char := encoder nextFromStream: stream.
			char = Character lf
				ifTrue: [ endOfLine := true ]
				ifFalse: [ out nextPut: char ] ] ]