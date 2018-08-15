private
wasInactiveForTooLong
	^ (Time millisecondsSince: lastActivity) > (heartbeat - (self timeout * 1000 * 2))