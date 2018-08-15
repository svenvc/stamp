accessing
commitFrame
	^ StampCommitFrame new
		transaction: self id;
		yourself