private
socketStream
	| socketStream |
	socketStream := SocketStream 
		openConnectionToHostNamed: self host 
		port: self port.
	socketStream 
		binary; 
		timeout: 5;
		autoFlush: false.
	^ socketStream