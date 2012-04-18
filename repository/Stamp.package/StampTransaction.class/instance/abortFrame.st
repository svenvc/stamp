accessing
abortFrame
	^ StampAbortFrame new
		transaction: self id;
		yourself