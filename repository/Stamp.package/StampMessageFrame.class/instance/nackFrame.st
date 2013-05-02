accessing
nackFrame
	^ StampNackFrame new
		id: self messageId;
		subscription: self subscription;
		yourself