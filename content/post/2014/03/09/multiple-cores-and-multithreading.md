+++
title = "Multiple Cores and Multithreading"
tags = ["programming", "concurrency"]
date = "2014-03-09"
+++

Have you ever seen advertisements for the latest computers which promote fancy processors with multi-core processors and
wonder exactly the advantage of having multiple cores is?

The most tempting explanation, although perhaps too simplistic, is that &ldquo;more is better&rdquo;. The most common
mistake is thinking that _n cores must run programs n times faster than one core_, ie a four core processor is
approximately four times faster than a single-core processor. Although _this has the potential to happen occasionally_,
the true benefits are actually slightly different. First, though, we must understand what a core _does_.

### What is a core?

A processor's &lsquo;core&rsquo; is its most fundamental unit. It is basically is the one part of the computer which
does any real _computing_. Cores basically handle all instructions a computer needs to execute, whether they are simple
for the computer (ie mathematical operations) or more difficult (ie rendering a Word document).

A computer does nothing more or less than execute computer programs it has been given. In turn, those programs are
nothing more or less than a **list** of mathematical instructions to be followed. (As such, anybody could technically
try and &lsquo;do&rsquo; a computer program, although it'd probably take a very long time.)

In simplistic terms, this means that a single core is essentially going down a list of instructions and performing each
one, in turn, to some effect.

### Multi-core Architecture

![Diagram of Dual Core Processor Architecture](/img/Dual_Core_Generic.svg)

As can be seen in this diagram, a multi-core processor has multiple cores connected in parallel. Like mentioned
previously, each core is essentially an agent performing a list of instructions. However, there are two questions that
this poses.

1. Does having multiple cores allow multiple programs to be run at the same time?
2. Does having multiple cores allow a single program to run faster?

The answer to both of these questions lies in the diagram. 

1. Notice in the diagram that multiple cores still share one common bus (a connection) with the rest of the computer.
   This mean having multiple cores is essentially like having many cooks in a cramped restaurant. Despite the many cooks,
   such a restaurant rarely gets enough customers to need to handle many different orders at once. Instead, often one (or
   sometimes) two cooks is all that is needed to handle every order. At the end of the day, although the computer may have
   a large capacity to do work, it can't fully leverage this across multiple programs because of the traffic across the
   bus. (Smart, modern operating systems still manage to get a lot done, but even they can't often fully utilize the cores
   available to them.) The choke point which is the dining room (the bus) often precludes getting multiple customers
   (programs) at once.

2. If this restaurant gets a complex order with many distinct dishes from a customer, can they distribute the work
   between them to serve him more quickly? Just like a recipe which calls for many distinct phases of preparation can be
   worked on at the same time from different angles by the cooks, a program which calls for many distinct operations can be
   distributed across multiple cores.

### Multithreading for Many Cooks

The important takeaway is that multiple cores is most beneficial for programs which are specifically written to leverage
having access to these multiple cores. This then shifts the onus of writing such programs to the authoring programmers.

On my current homework assignment in my Network-centric Programming class, we are tasked to take a 
[web proxy](http://en.wikipedia.org/wiki/Web_proxy#Web_proxy_servers) and make it multi-threaded 
(where using multiple threads enables a processor with multiple cores to process those multiple threads concurrently). 
This is tricky because of a problem I didn't mention until now: sharing resources. 

Two cooks in a restaurant can't **both** be using a knife at the same time. For them to blindly try to do so will most
likely result in one of them getting injured, bleeding all over the kitchen, and forcing the restaurant to abruptly
cancel dinner. Even if this doesn't happen, the near miss may result in a butchered dish. This is approximately
analogous to programming with multiple threads. When threads are trying to work towards a common goal &mdash; whether or
not they need to actively &ldquo;speak&rdquo; with each other &mdash; they need to be careful to not attempt to utilize
an otherwise common resource if it's otherwise in use. At best, this can interfere with the normal operation of a
program; at worst, it is fatal.

#### A Form of Solution

A special family of programming constructs known as _mutex locks_, or _mutual exclusion locks_, allow a thread to signal
others that it has exclusive access to a shared resource. Notwithstanding these special constructs, dealing with sharing
locks and otherwise minding the distinction between threads can easily become tedious, and mistakes made behind the
scenes often aren't transparent to programmers.

In general, these multithreading solutions are taken for granted every day in order to achieve the quickest and most
concurrent programs possible with modern computer architectures. However, because mistakes made with multiple threads
are very difficult to catch as they aren't always fatal and don't even always result in actual errors, certain mistakes
can slip through to production code. If you notice a quirky program, perhaps it is multithreaded.
