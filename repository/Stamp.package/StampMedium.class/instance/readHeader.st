reading
readHeader
	| line |
	^ (line := self readLine) isEmpty
		ifTrue: [ nil ]
		ifFalse: [ | elements key value |
			elements := $: split: line.
			elements size = 2 
				ifFalse: [ self error: 'Incorrect header, no colon found' ].
			key := self decodeValue: elements first.
			value := self decodeValue: elements second.
			key -> value ]