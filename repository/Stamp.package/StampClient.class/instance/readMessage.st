reading
readMessage
	^ self readSuchThat: [ :frame | frame command = #MESSAGE ]