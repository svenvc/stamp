private
unescape: char
	char = $n ifTrue: [ ^ Character linefeed ].
	char = $c ifTrue: [ ^ $: ].
	char = $\ ifTrue: [ ^ char ].
	self error: 'Unrecognized escape'.