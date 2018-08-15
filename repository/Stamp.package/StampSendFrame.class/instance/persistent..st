accessing
persistent: boolean
	"This is a RabbitMQ extension. Setting the persistent header to true has the effect of making the message persistent. Receipts for SEND frames with persistent:true are not sent until a confirm is received from the broker. MESSAGE frames for persistent messages will contain a persistent:true header."
	
	self headerAt: #persistent put: boolean printString