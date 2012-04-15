writing
writeBodyOn: stampMedium
	self hasBody
		ifTrue: [ 
			"For now assume UTF8 textual content"
			stampMedium nextPutString: self body ]