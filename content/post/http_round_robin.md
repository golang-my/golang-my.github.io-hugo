+++
date = "2016-08-23T19:32:34+08:00"
image = ""
math = false
draft = false
tags = ["golang", "net/http", "roundrobin", "handler"]
title = "Easy round robin with net/http"
+++

By [Chee Leong](https://github.com/klrkdekira)

## Introduction

Golang came bundled with a pretty comprehensive HTTP Standard Library a.k.a [net/http](https://golang.org/pkg/net/http/).

I'm going to show you how to do a simple round robin HTTP server with Golang's Duck Typing a.k.a **Handler** interface.

And because Golang Playground doesn't work well with HTTP server, I'm not going to provide the link, so you have to download the script and run it yourself.

## Basic

So, let's start with the boilerplate we're going to use for the rest of the guide.

We will be creating a program that starts a HTTP server and a client to request the HTTP server, then exit.

{{< gist klrkdekira 49ee872b2e0c493d6b3d01c641c0f695 >}}

First, it's very important to know **Server.Handler** accepts a **Handler** interface.

So right now we set up a server that respond **Hello, World!** that runs on **127.0.0.1:9090**

For the following part is just the boilerplate of a HTTP request,

1. Create a **Request** object.
2. Call **Client.Do**.
3. Read the response.
4. Print the response.

Notice I call fatal whenever an error occurs, this is very important.

**Rule, fail as soon as possible, fail quick and loudly is better than late and silently.**.

## Custom Handler

Now, we're going to create our own **Handler** so we can perform our tricks later.

{{< gist klrkdekira 95b4b9ff43659e2de781d552455ec12d >}}

As you can see, we've added **RobinHood**, an empty struct.

Since **RobinHood** implemented ServeHTTP(http.ResponseWriter, *http.Request), it fulfills and qualifies as **Handler**.

## Basic Load Balancer

Let's implement our basic round robin **Handler**

{{< gist klrkdekira 188b981402118d8b5c5136c3d08861bc >}}

As you can see, I've added several attributes to the **RobinHood** struct, let's go through

* counter - keep track of current state to know which handler to call.
* mu - mutual exclusive lock to maintain integrity of **counter**
* one, two, three - http handler funcs

**ServeHTTP** for **RobinHood** is also updated to serve the handler funcs in a round robin manner.

I've also put the bootstrapping of **RobinHood** as the function **newRobinHood**, just to avoid typing that over and over again.

**newHandlerFunc** is added also to save me from repeating the handler func boilerplate.

To demonstrate the working of our basic round robin engine, I'm running the the HTTP request in a loop of 5.

Run this and you should expect the same output as the included **response.txt**.

## Chaining HTTP Handlers

Now, instead of hacking and limit ourselves to only 3 handler funcs, we can actually implement a round robin of a list of HTTP Handlers.

The changes involved are very small.

{{< gist klrkdekira b6899a334466cfc2c81906b0f00a35af >}}

I've removed **one**, **two**, **three**, added **handler** a slice of **http.Handler**. Updated the **newRobinHood** bootstrapper.

**newHandlerFunc** is also removed and now **newHandler** is added since we are accepting **Handler** instead.

Now, we are not limited to the predefined handler func capacity that **RobinHood** used to have.

See line `45-46`, with just a few lines of change, we made **RobinHood** more scalable. And that's about it.

## Bonus

However, there's one more trick I want to show.

{{< gist klrkdekira 90be7ace5c0fb7f80b98ff60ed21579c >}}

We can actually modify the pool of handlers.

I've added **AddHandler**, a way to slot in handler, of course with the similar code, you can remove or modify the sequence of Handlers.

**Note** The mutex lock is very important in this.

At `line 86`, I put in a new handler and request the server 5 times again. Check the results.

## Resources

* [Go by Example - Interface](https://gobyexample.com/interfaces)
* [net/http Handler](https://golang.org/pkg/net/http/#Handler)
* [Duck typing](https://en.wikipedia.org/wiki/Duck_typing)
