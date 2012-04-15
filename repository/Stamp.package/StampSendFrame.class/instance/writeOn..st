writing
writeOn: stampMedium
	self contentLength: (stampMedium encodedLengthOf: self body).
	super writeOn: stampMedium