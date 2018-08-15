writing
writeHeadersOn: stampMedium
	self headers 
		keysAndValuesDo: [ :key :value |
			stampMedium nextPutHeader: key value: value ].
	stampMedium endLine