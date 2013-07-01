initialize-release
close
	medium ifNotNil: [ 
		[ [ self disconnect ] on: ConnectionClosed, ConnectionTimedOut do: [ ] ]
			ensure: [ self closeMedium ].
		connectFrame := connectedFrame := nil ]