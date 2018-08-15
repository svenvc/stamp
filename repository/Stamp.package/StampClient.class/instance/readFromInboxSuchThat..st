reading
readFromInboxSuchThat: block
	| frame |
	frame := inbox detect: block ifNone: [ ^ nil ].
	inbox remove: frame.
	^ frame
