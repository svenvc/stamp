reading
readSuchThat: block
	| frame started |
	self writeHeartbeatIfNeeded.
	(self readFromInboxSuchThat: block) ifNotNil: [ :found | ^ found ].
	started := Time millisecondClockValue.
	[
		frame := self readNextFrame.
		StampFrameReadEvent new frame: frame; emit.
		frame command isEmpty
			ifFalse: [ 
				(block value: frame)
					ifTrue: [ ^ frame ]
					ifFalse: [ inbox add: frame ] ].
		(Time millisecondsSince: started) / 1000 > self timeout
			ifTrue: [ ^ self failedToReadInTimeout ] ] repeat