accessing
subscribeFrame
	^ subscribeFrame 
		ifNil: [
			subscribeFrame := StampSubscribeFrame new ]