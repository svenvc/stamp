accessing
persistent
	^ (self headerAt: #persistent ifAbsent: [ #false ]) = #true