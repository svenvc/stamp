private
unescapeString: string
	| in |
	in := string readStream.
	^ String new: string size streamContents: [ :out |
		[ in atEnd ] whileFalse: [ | char |
			(char := in next) = $\
				ifTrue: [ out nextPut: (self unescape: in next) ]
				ifFalse: [ out nextPut: char ] ] ]