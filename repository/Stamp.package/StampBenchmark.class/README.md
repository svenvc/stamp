I am StampBenchmark.

[ StampBenchmark new writeCount: 1000 ofSize: 1024 ] timeToRun.

[ StampBenchmark new readCount: 1000 ] timeToRun.

[ StampBenchmark new writeNoReceiptCount: 1000 ofSize: 1024 ] timeToRun.

[ StampBenchmark new readNoAckCount: 1000 ] timeToRun.
