initialize-release
open
	| frame |
	self close.
	self write: self connectFrame.
	frame := self read.
	"We should do protocol negociation too"
	frame command = #CONNECTED
		ifTrue: [ connectedFrame := frame ].
	^ self isConnected