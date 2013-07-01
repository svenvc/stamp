running
writeNoReceiptCount: count ofSize: size
	| client frame |
	client := self client.
	^ [ 
	client open.
	1 to: count do: [ :each | 
		frame := self sendFrameOfSize: size tag: each for: client. 
		client writeNoFlush: frame ].
	count ] ensure: [ client close ]