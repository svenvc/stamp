writing
writeNoFlush: frame
	frame writeOn: self medium.
	self log: [ 'Wrote ', frame printString ]