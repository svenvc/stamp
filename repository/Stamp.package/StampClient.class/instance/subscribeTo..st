convenience
subscribeTo: destination
	| subscription |
	subscription := self newSubscriptionTo: destination.
	self write: subscription subscribeFrame.
	^ subscription