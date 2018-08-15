accessing
headerAt: headerName ifAbsent: block
	^ self headers at: headerName ifAbsent: block