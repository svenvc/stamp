testing
isConnected
	^ self medium isConnected 
		and: [ self connectedFrame notNil ]