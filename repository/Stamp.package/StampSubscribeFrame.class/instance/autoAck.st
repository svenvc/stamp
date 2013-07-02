accessing
autoAck
	"When the ack mode is auto, then the client does not need to send the server ACK frames for the messages it receives. The server will assume the client has received the message as soon as it sends it to the client. This acknowledgment mode can cause messages being transmitted to the client to get dropped. This is the default."
	
	self ack: #auto