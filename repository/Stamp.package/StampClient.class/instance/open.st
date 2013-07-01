initialize-release
open
	self close.
	self write: self connectFrame.
	connectedFrame  := self readSuchThat: [ :frame | frame command = #CONNECTED ].
	self setActualHeartbeat.
	connectFrame acceptVersion = connectedFrame version
		ifFalse: [ self error: 'Incompatible STOMP version' ].
	^ self isConnected