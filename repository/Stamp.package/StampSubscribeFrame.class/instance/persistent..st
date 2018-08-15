accessing
persistent: boolean
	"This is a RabbitMQ extension. The STOMP adapter supports durable topic subscriptions. Durable subscriptions allow clients to disconnect from and reconnect to the STOMP broker as needed, without missing messages that are sent to the topic. Topics are neither durable nor transient, instead subscriptions are durable or transient. Durable and transient can be mixed against a given topic. To create a durable subscription, set the persistent header to true in the SUBSCRIBE frame. When creating a durable subscription, the id header must be specified."
	
	self headerAt: #persistent put: boolean printString