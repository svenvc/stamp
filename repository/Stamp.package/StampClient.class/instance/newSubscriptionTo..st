convenience
newSubscriptionTo: destination
	^ StampSubscription new
		id: self nextId;
		destination: destination;
		yourself