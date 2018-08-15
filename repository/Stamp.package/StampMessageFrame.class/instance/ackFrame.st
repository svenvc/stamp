accessing
ackFrame
	^ StampAckFrame new
		id: self messageId;
		subscription: self subscription;
		yourself