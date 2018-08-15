accessing
contentLength: length
	self headerAt: #'content-length' put: length asString