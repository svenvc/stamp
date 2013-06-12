accessing
randomString: size
	^ String new: size streamContents: [ :out |
		 size timesRepeat: [ 
			out nextPut: 'abcdefghijklmnopqrstuvwxyz' atRandom ] ]