accessing
nextId
	idGenerator ifNil: [ idGenerator := 0 ]. 
	idGenerator := idGenerator + 1.
	^ 'stamp-client-id-', idGenerator asString