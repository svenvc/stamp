accessing
sendFrameOfSize: size tag: number for: client
	| frame body |
	frame := client newSendFrameTo: self queue.
	body := self messageOfSize: size tag: number.
	binary
		ifTrue: [ frame bytes: body ]
		ifFalse: [ frame text: body ].
	^ frame