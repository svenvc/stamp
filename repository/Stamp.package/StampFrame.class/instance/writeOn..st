writing
writeOn: stampMedium
	stampMedium 
		nextPutString: self command; 
		endLine.
	self writeHeadersOn: stampMedium.
	self writeBodyOn: stampMedium.
	stampMedium endFrame