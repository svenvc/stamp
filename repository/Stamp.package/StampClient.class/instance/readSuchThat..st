reading
readSuchThat: block
	| frame started |
	self writeHeartbeatIfNeeded.
	(self readFromInboxSuchThat: block) ifNotNil: [ :found | ^ found ].
	started := Time millisecondClockValue.
	[
		frame := self readNextFrame.
		frame command isEmpty
			ifFalse: [ 
				self log: [ 'Read ', frame printString ].
				(block value: frame)
					ifTrue: [ ^ frame ]
					ifFalse: [ inbox add: frame ] ].
		(Time millisecondsSince: started) / 1000 > self timeout
			ifTrue: [ ^ self failedToReadInTimeout ] ] repeat