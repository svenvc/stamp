options
host
	^ self optionAt: #host ifAbsent: [ 'localhost' ]