private
socketStream
	| socketStream |
	socketStream := SocketStream 
		openConnectionToHostNamed: self host 
		port: self port.
	socketStream 
		binary; 
		autoFlush: false.
	^ socketStream