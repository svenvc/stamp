options
port
	^ self optionAt: #port ifAbsent: [ StampConstants defaultPort ]