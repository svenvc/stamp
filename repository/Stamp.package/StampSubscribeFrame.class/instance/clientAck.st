accessing
clientAck
	"When the ack mode is client, then the client MUST send the server ACK frames for the messages it processes. If the connection fails before a client sends an ACK frame for the message the server will assume the message has not been processed and MAY redeliver the message to another client. The ACK frames sent by the client will be treated as a cumulative acknowledgment. This means the acknowledgment operates on the message specified in the ACK frame and all messages sent to the subscription before the ACK'ed message. In case the client did not process some messages, it SHOULD send NACK frames to tell the server it did not consume these messages."
	
	self ack: #client