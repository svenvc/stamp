accessing
persistent
	"See #persistent:"
	
	^ (self headerAt: #persistent ifAbsent: [ #false ]) = #true