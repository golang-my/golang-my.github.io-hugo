+++
date = "2016-08-13T10:42:53+08:00"
image = ""
title = "Go routine and channel explained with fizzbuzz"
draft = false
math = false
tags = ["golang", "channel", "routine", "fizzbuzz"]
+++

By [Chee Leong](https://github.com/klrkdekira)

I'm trying to show the common pattern of multiplexing via gochannel and goroutine.

## Definition

```
Fizz buzz is a group word game for children to teach them about division.[1] Players take turns to count incrementally, replacing any number divisible by three with the word "fizz", and any number divisible by five with the word "buzz".
```

**Attention!** Go Playground operation is single threaded hence output is always in order of the input. Try the code out at your computer for multithread goodness.

### Basic

Let's start with the basic example,

{{< gist klrkdekira 4e0b1d581488c2c22ca4631e28a11115 >}}

[Playground Link](https://play.golang.org/p/53kVtkPKCn)

As demonstrated above, each loop contains blocking operation of processing and output.

### Goroutine

To start applying goroutine, the inner loop operations are moved to a separate function.

To invoke a goroutine, simply append a `go` keyword in front of the function call.

{{< gist klrkdekira 0e49f80c8c92eaead339044375c23c26 >}}

[Playground Link](https://play.golang.org/p/BXB6Eg9fNn)

As you can see, we rely on a blocking `Sleep` operation to stall the `main` from exiting too early. However this is not good idea because we have no idea how long it takes for each processes to finish running.

### Synchronization

#### Synchronization via WorkGroup

Although it is possible to do job waiting with channel, it is recommended to use [WaitGroup](https://golang.org/pkg/sync/#WaitGroup)

{{< gist klrkdekira 680545cafff3018d4daa6e843dcd27c9 >}}

[Playground Link](https://play.golang.org/p/9HJOVQhFjz)

Now, we made sure all goroutine executed before exit.

Even though the current code looks good enough, `fmt.Println` is actually a io operation.

Once the write buffer is big enough, the output will be contaminated, ie part of line 1 will have fragment of line 3.

To avoid undesirable side effect, we'll apply multiplexing.

### Multiplex

Unfortunately, I won't be covering channel here. For the uninitiated, it is a pipe.

Read more about channel here.

* [Channel](https://gobyexample.com/channels)
* [Channel Buffering](https://gobyexample.com/channel-buffering)
* [Channel Direction](https://gobyexample.com/channel-directions)

The diagram of multiplexing we're going to apply here

```
     inputChan                | 0 | ouputChan
main ========> fizzbuzzWorker | 1 | ========> printWorker
                              | 2 |
                              | 3 |
```

The changes for this implement might be a bit drastic

{{< gist klrkdekira 6edb0a66a618532b9c411f388fed7b42  >}}

[Playground Link](https://play.golang.org/p/z0ak0vaHXE))

As you can see, the last part is declared first, aka in our example the `printWorker` and `outputChan`.

This is to assure the worker is consuming the piped message as soon as possible.

Since `printWorker` is only a single process, we'll be using a channel to signal the conclusion of the goroutine.

`printWorker` listen to incoming `string` message and print them out on the terminal.

Then, we starts n (system core) amount of `fizzbuzzWorker` goroutine.

`fizzbuzzWorker` ingests `int` input, and ouput `string`

Now, with all the worker set, we start to feed `inputChan`. Once it's finished, we closed `inputChan` so our `fizzbuzzWorker` knows when there's no more job and exit.

**Warning**, failed to close a channel will result in a deadlock, the best case is the compiler or runtime throws panic immediately, worst case is the program stucked but still run indefinitely.

Next, the program waits for all `n` of `fizzbuzzWorker` to finish their task, then we'll close `outputChan` so `printWorker` knows when to stop.

Once, `printWorker` finished its job, the `printDone` is signalled and program is now exited happily.

## References

1. [Fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz)
2. [Multiplexing](https://en.wikipedia.org/wiki/Multiplexing)
3. [Go by Example](https://gobyexample.com)