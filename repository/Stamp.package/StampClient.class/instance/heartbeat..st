options
heartbeat: milliseconds
	self timeout * 1000 * 4 < milliseconds
		ifFalse: [ self error: 'heartbeat must be larger than 4 times the timeout' ].
	self optionAt: #heartbeat put: milliseconds