initialize-release
close
	medium ifNotNil: [ 
		[ self disconnect ]
			ensure: [ self closeMedium ].
		connectedFrame := nil ]