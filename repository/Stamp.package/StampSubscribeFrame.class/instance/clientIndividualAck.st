accessing
clientIndividualAck
	"When the ack mode is client-individual, the acknowledgment operates just like the client acknowledgment mode except that the ACK or NACK frames sent by the client are not cumulative. This means that an ACK or NACK frame for a subsequent message MUST NOT cause a previous message to get acknowledged."
	
	self ack: #'client-individual'