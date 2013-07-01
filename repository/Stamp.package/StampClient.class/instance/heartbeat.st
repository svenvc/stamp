options
heartbeat
	^ self optionAt: #heartbeat ifAbsent: [ 2000 "milliseconds" ]