reading
readBodyFrom: stampMedium
	self body: (stampMedium 
		readBody: self contentLength 
		type: self contentType)