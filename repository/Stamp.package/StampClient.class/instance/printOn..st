printing
printOn: stream
	super printOn: stream.
	stream nextPut: $(.
	stream << self host; nextPut: $:; print: self port; space; << self virtualHost.
	stream space; << (self isConnected ifTrue: [ 'connected' ] ifFalse: [ 'not connected' ]).
	stream nextPut: $)