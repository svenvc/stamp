reading
readBodyFrom: stampMedium
	body := stampMedium 
		readBody: self contentLength 
		type: self contentType