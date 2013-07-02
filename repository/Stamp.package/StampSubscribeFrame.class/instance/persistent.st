accessing
persistent
	"See #persisten:"
	
	^ (self headerAt: #persistent ifAbsent: [ #false ]) = #true