options
heartbeat: milliseconds
	milliseconds < (self timeout * 1000)
		ifFalse: [ self error: 'heartbeat cannot be smaller than timeout' ].
	self optionAt: #heartbeat put: milliseconds