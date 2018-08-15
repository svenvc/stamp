reading
readNextFrame
	| frame |
	frame := StampFrame readFrom: self medium.
	self touch.
	^ frame command = #ERROR
		ifTrue: [ StampError signalFor: frame ]
		ifFalse: [ frame ]