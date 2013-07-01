private
log: message
	self debug ifTrue: [ super logCr: message value ]