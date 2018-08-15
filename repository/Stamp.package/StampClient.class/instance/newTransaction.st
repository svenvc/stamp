convenience
newTransaction
	^ StampTransaction new
		id: self nextId;
		yourself