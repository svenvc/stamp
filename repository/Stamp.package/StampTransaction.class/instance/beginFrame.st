accessing
beginFrame
	^ beginFrame ifNil: [
		beginFrame := StampBeginFrame new ]