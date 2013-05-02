accessing
headerAt: headerName put: headerValue
	"Set headerName to headerValue. 
	Note that according to the 1.2 spec, Repeated Header Entries, the first one wins."
	
	^ (self hasHeader: headerName)
		ifFalse: [ self headers at: headerName put: headerValue ]