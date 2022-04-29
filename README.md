# stamp

[![CI](https://github.com/svenvc/stamp/actions/workflows/CI.yml/badge.svg)](https://github.com/svenvc/stamp/actions/workflows/CI.yml)

Stamp is an implementation of STOMP (Simple (or Streaming) Text Oriented Message Protocol) for Pharo, a protocol to interact with message-oriented middleware (MOM).

More specifically, Stamp implements STOMP 1.2 and was tested against RabbitMQ 3.x. Other message-oriented middleware implementations accessible through STOMP include Apache ActiveMQ, Glassfish Open MQ and Fuse Message Broker based on Active MQ - but these have not yet been tested.

Messaging middleware is an important technology for building scaleable and flexible enterprise software architectures.


## References

- https://en.wikipedia.org/wiki/Streaming_Text_Oriented_Messaging_Protocol
- http://stomp.github.io
- https://rabbitmq.com
- https://rabbitmq.com/stomp.html

## Installation

Execute the following Metacello baseline load script

```Smalltalk
Metacello new
	baseline: 'Stamp';
	repository: 'github://svenvc/stamp/repository';
	load
```
 

## Dependency

Add the following code to your Metacello baseline

```Smalltalk
spec 
   baseline: 'Stamp' 
   with: [ spec repository: 'github://svenvc/stamp/repository' ]
```

MIT License.
