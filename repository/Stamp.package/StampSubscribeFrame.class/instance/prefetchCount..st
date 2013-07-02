accessing
prefetchCount: integer
	"This is a RabbitMQ extension. The prefetch count for all subscriptions is set to unlimited by default. This can be controlled by setting the prefetch-count header on SUBSCRIBE frames to the desired integer count."
	
	self headerAt: #'prefetch-count' put: integer asString