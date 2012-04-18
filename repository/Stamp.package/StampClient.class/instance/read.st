reading
read
	| frame |
	[
		frame := StampFrame readFrom: self medium.
		frame command isEmpty ] whileTrue.
	^ frame