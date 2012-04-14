I am StampFrame.
I am the abstract superclass of an object hierarchy representing STOMP frames.

Simple (or Streaming) Text Oriented Message Protocol (STOMP), is a simple text-based protocol, designed for working with Message Oriented Middleware. It provides an interoperable wire format that allows STOMP clients to talk with any Message Broker supporting the protocol. It is thus language-agnostic, meaning a broker developed for one language or platform can receive communications from client software developed in another language.

This code implements STOMP 1.1

--- References ---

http://stomp.github.com/
http://en.wikipedia.org/wiki/Streaming_Text_Oriented_Messaging_Protocol

--- BNF ---

LF = <US-ASCII new line (line feed) (octet 10)>
OCTET = <any 8-bit sequence of data>
NULL = <octet 0>

frame-stream = 1*frame

frame = command LF
	 *( header LF )
	LF
	*OCTET
	NULL
	*( LF )

command = client-command | server-command

client-command = "SEND"
                      | "SUBSCRIBE"
                      | "UNSUBSCRIBE"
                      | "BEGIN"
                      | "COMMIT"
                      | "ABORT"
                      | "ACK"
                      | "NACK"
                      | "DISCONNECT"
                      | "CONNECT"
                      | "STOMP"

server-command = "CONNECTED"
                      | "MESSAGE"
                      | "RECEIPT"
                      | "ERROR"

header = header-name ":" header-value
header-name = 1*<any OCTET except LF or ":">
header-value  = *<any OCTET except LF or ":"> 
