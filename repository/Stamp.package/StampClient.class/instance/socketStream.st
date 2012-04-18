private
socketStream
	| socketStream |
	socketStream := SocketStream 
		openConnectionToHostNamed: self host 
		port: self port.
	socketStream 
		binary; 
		timeout: 1;
		autoFlush: false.
	^ socketStream