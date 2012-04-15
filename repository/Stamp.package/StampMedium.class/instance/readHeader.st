reading
readHeader
	| line |
	^ (line := self readLine) isEmpty
		ifTrue: [ nil ]
		ifFalse: [ | elements |
			elements := $: split: line.
			elements size = 2 ifFalse: [ self error: 'Incorrect header, no colon found' ].
			elements first -> elements second ]