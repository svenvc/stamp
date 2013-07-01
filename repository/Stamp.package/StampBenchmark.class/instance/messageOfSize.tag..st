accessing
messageOfSize: size tag: number
	(self messageOfSize: size) writeStream nextPutAll: (self tag: number).
	^ message