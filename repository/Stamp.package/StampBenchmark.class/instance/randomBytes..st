private
randomBytes: size
	^ ByteArray new: size streamContents: [ :out |
		 size timesRepeat: [ 
			out nextPut: 100 atRandom ] ]