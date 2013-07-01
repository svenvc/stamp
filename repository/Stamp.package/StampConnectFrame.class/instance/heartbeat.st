accessing
heartbeat
	^ ($, split: (self headerAt: #'heart-beat' ifAbsent: [ '0,0' ])) 
			collect: [ :each | each trimBoth asInteger ]