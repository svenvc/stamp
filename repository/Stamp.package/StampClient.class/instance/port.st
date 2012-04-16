accessing
port
	^ port ifNil: [ 
		port := StampConstants defaultPort ]