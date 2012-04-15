reading
readEndFrame
	stream next = 0 ifFalse: [ self error: 'End of frame missing' ].
	