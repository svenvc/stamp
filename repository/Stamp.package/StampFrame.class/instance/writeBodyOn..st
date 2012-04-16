writing
writeBodyOn: stampMedium
	self hasBody
		ifTrue: [ 
			self body isString
				ifTrue: [ stampMedium nextPutString: self body ]
				ifFalse: [ stampMedium nextPutBytes: self body ] ]