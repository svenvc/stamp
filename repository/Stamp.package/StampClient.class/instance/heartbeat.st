options
heartbeat
	^ self optionAt: #heartbeat ifAbsent: [ 60*1000 "milliseconds" ]