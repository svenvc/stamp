private
writeHeartbeatIfNeeded
	heartbeat ifNil: [ ^ nil ].
	(Time millisecondsSince: lastActivity) > (heartbeat - (self timeout * 1000* 2))
		ifTrue: [ 
			self 
				writeHeartbeat; 
				touch  ]