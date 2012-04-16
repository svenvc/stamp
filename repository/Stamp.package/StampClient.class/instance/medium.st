accessing
medium
	^ medium ifNil: [ 
		medium := StampMedium on: self socketStream ]