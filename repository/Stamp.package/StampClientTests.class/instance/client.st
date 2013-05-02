accessing
client
	| client |
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	"client debug: true."
	^ client