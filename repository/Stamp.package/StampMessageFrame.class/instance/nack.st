accessing
nack
	^ StampNackFrame new
		messageId: self messageId;
		subscription: self subscription;
		yourself