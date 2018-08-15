reading
readHeader
	| line |
	^ (line := self readLine) isEmpty
		ifTrue: [ nil ]
		ifFalse: [ | index key value |
			index := line indexOf: $: .
			index = 0
				ifTrue: [ self error: 'Incorrect header, no colon found' ].
			key := self decodeValue: (line copyFrom: 1 to: index - 1).
			value := self decodeValue: (line copyFrom: index + 1 to: line size).
			key -> value ]