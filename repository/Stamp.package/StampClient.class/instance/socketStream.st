private
socketStream
	| socketStream |
	socketStream := ZdcSocketStream 
		openConnectionToHostNamed: self host 
		port: self port.
	socketStream 
		binary; 
		timeout: self timeout;
		autoFlush: false.
	^ socketStream