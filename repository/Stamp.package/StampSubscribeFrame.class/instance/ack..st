accessing
ack: string
	"See #autoAck, #clientAck and #clientIndividualAck"
	
	self assert: (#(#auto #client #'client-individual') includes: string).
	self headerAt: #ack put: string