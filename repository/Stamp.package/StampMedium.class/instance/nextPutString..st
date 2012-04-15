writing
nextPutString: string
	string do: [ :each |
		encoder nextPut: each toStream: stream ]