testing
isConnected
	medium ifNil: [ ^ false ].
	^ self medium isConnected 
		and: [ self connectedFrame notNil ]