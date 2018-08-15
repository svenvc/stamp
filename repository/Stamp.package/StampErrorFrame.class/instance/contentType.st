accessing
contentType
	".. Otherwise, the receiver SHOULD consider the body to be a binary blob"
	^ self headerAt: #'content-type' ifAbsent: [ 'application/octet-stream' ]