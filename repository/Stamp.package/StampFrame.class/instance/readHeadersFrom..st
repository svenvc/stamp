reading
readHeadersFrom: stampMedium
	| association |
	[ (association := stampMedium readHeader) notNil ] 
		whileTrue: [
			self headers size >= StampConstants maxNumberOfHeaders 
				ifTrue: [ self error: 'Too many headers' ].
			self headers add: association ]