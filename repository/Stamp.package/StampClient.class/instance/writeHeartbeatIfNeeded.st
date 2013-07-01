private
writeHeartbeatIfNeeded
	heartbeat ifNil: [ ^ nil ].
	(Time millisecondsSince: lastActivity) > heartbeat 
		ifTrue: [ 
			self 
				writeHeartbeat; 
				touch  ]