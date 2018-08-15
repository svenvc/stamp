accessing
heartbeat: values
	self 
		headerAt: #'heart-beat' 
		put: ('{1},{2}' format: { values first asString. values second asString } )