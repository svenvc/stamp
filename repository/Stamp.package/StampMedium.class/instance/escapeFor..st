private
escapeFor: char
	char = Character linefeed ifTrue: [ ^ 110 ].		"ASCII char n"
	char = $: ifTrue: [ ^ 58 ].		"ASCII char c"
	char = $\ ifTrue: [ ^ 92 ].		"ASCII char \"
	self error: 'Unrecognized escape'