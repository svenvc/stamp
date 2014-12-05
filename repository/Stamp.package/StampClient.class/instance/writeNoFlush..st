writing
writeNoFlush: frame
	frame writeOn: self medium.
	StampFrameWrittenEvent new frame: frame; emit.
