private
log: message
	debug ifTrue: [ super logCr: message value ]