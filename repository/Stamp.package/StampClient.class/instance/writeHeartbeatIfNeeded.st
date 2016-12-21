private
writeHeartbeatIfNeeded
	heartbeat ifNil: [ ^ nil ].
	self wasInactiveForTooLong
		ifTrue: [ self writeHeartbeat ]