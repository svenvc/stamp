I am StampBenchmark.

Text messages (UTF-8):

[ StampBenchmark new writeCount: 1000 ofSize: 1024 ] timeToRun.

[ StampBenchmark new readCount: 1000 ] timeToRun.

[ StampBenchmark new writeNoReceiptCount: 1000 ofSize: 1024 ] timeToRun.

[ StampBenchmark new readNoAckCount: 1000 ] timeToRun.

Binary messages:

[ StampBenchmark new binary; writeCount: 1000 ofSize: 1024 ] timeToRun.

[ StampBenchmark new binary; readCount: 1000 ] timeToRun.

[ StampBenchmark new binary; writeNoReceiptCount: 1000 ofSize: 1024 ] timeToRun.

[ StampBenchmark new binary; readNoAckCount: 1000 ] timeToRun.
