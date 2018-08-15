writing
nextPutHeader: key value: value
	self
		nextPutStringValueEncoded: key;
		nextPutString: ':';
		nextPutStringValueEncoded: value;
		endLine