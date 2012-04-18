accessing
ackFrame
	^ StampAckFrame new
		messageId: self messageId;
		subscription: self subscription;
		yourself