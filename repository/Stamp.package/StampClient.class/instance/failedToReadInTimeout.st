private
failedToReadInTimeout
	^ ConnectionTimedOut signal: 'Could not read matching message before timeout'