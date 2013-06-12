private
socketStream
	| socketStream |
	socketStream := ZdcSocketStream 
		openConnectionToHostNamed: self host 
		port: self port.
	socketStream 
		binary; 
		timeout: 1;
		autoFlush: false.
	^ socketStream