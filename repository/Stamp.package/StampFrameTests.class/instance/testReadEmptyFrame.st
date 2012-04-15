testing
testReadEmptyFrame
	| frame |
	frame := StampFrame readFrom: (StampMedium on: #[ 10 ] readStream).
	self assert: frame = StampEmptyFrame new