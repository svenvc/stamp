accessing
contentLength
	^ (self headerAt: #'content-length' ifAbsent: [ nil ])
		ifNotNil: [ :value | value asInteger ]