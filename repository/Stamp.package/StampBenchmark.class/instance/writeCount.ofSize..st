running
writeCount: count ofSize: size
	| client frame |
	client := self client.
	^ [ 
	client open.
	1 to: count do: [ :each | 
		frame := self sendFrameOfSize: size tag: each for: client. 
		client writeWithReceipt: frame ].
	count ] ensure: [ client close ]