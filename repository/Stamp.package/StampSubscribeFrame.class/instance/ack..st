accessing
ack: string
	self assert: (#(#auto #client #'client-individual') includes: string).
	self headerAt: #ack put: string