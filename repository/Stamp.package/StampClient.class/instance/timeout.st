options
timeout
	^ self optionAt: #timeout ifAbsent: [ 1 "second" ]