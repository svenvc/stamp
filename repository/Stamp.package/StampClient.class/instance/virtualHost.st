options
virtualHost
	^ self optionAt: #virtualHost ifAbsent: [ '/' ]