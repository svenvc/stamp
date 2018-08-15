writing
writeNoFlush: frame
	frame writeOn: self medium.
	self touch.
	StampFrameWrittenEvent new frame: frame; emit
