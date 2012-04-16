initialize-release
open
	| frame |
	self close.
	self connectFrame writeOn: self medium.
	frame := StampFrame readFrom: self medium.
	"We should do protocol negociation too"
	frame command = #CONNECTED
		ifTrue: [ connectedFrame := frame ].
	^ self isConnected