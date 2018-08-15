accessing
tag: number
	^ binary
		ifTrue: [ number asByteArray, #[ 0 0 ] ]
		ifFalse: [ number asString, '  ' ]