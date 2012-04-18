accessing
nackFrame
	^ StampNackFrame new
		messageId: self messageId;
		subscription: self subscription;
		yourself