+++
date = "2017-06-18T11:07:02-04:00"
description = "Wherein I discuss some of the interesting aspects of how Clojure achieves its variable concepts in a thread-safe manner."
tags = ["clojure", "programming"]
title = "Clojure and the Esoteric Mysteries of Vars"
+++

I recently had the drive/opportunity to deep-dive on how Clojure's namespaces
function and how they provide a simple abstraction using the concept of Clojure's
&ldquo;`Var`s&rdquo;. Here is a deep-dive on how they work. This is a two-part
series. The next part of the series is available at
[Clojure and the Esoteric Mysteries of Namespaces]({{<relref "clojure-and-the-esoteric-mysteries-of-ns.md">}}).

## Vars: A Simplified Model of Variables

One of Clojure's essential motivations is to provide a hosted runtime for 
easily concurrent programs, wherein most of the challenges of locking and
thread-safety are provided &ldquo;for free&rdquo; (at least in the sense of
the programmer not having to worry about these low-level concepts). To that end,
Clojure implements its variables differently than most other languages.

In your typical programming runtime, variables describe locations in memory
containing primitive or structured data. These can be anything from primitive
numerical types such as integers and strings to structured types. This closely
reflects how the machine itself views data (as locations in memory containing
raw values), but presents challenges for concurrent programming:

* Global variables are easy enough for reading, but if an update to a global
  variable needs to occur, a lot of locking needs to occur.
* If multiple parallel threads of execution want to read or write variables
  (whether local or global) concurrently, some threads may have stale data.
* If updating structure data like a `struct` or a `class` object, and the update
  is not done atomically (in one clean shot), some threads of execution can read
  inconsistent state from the `struct`/`class` object.

When writing concurrent programs, there is a tension between the need for
variables to be accessed or even updated from multiple isolated contexts
(threads) concurrently, which requires indirections and locking, and for them
to perform efficiently, which suffers from indirection. Generally, there is an
implicit assumption that it is only acceptable to use concurrency in programs
which can accept a minor amount of locking and indirection; if this was not so,
then concurrency would not be acceptable.

Clojure directly addresses this tension through the use of a clever data
structure called the `Var`, defined in 
[`clojure.lang.Var`](https://github.com/clojure/clojure/blob/master/src/jvm/clojure/lang/Var.java).
In a nutshell, the `Var` works as follows:

* All &ldquo;variables&rdquo; in the Clojure runtime are instances of `Var`
* `Var`s support two modes of operation, one fast and global, the other slower
  and thread-local:
  1. Ordinarily, a `Var` object contains a value and some basic locking primitives.
     Whenever a Clojure program asks for a value (from a `Var`) which has not
     been modified, that value is dereferenced cheaply, with a quick return path.
  1. The basic value, called the &ldquo;root&rdquo; value, can be atomically
     swapped out for another value at any time. This is considered a global
     update. In practice it is rarely required, because &mdash;
  1. A `Var` can be declared in advance as being _dynamic_. If and when a `Var`
     is dynamic, a *local thread of execution* may begin declaring *local*
     overrides for the value of the `Var`. This is called a `binding`.
     Within those thread-local overrides, the value of the `Var` can be easily
     tweaked using functions like `set!`.
     The moment that any thread anywhere in the program begins `binding` on a
     particular `Var`, that `Var` globally switches from its fast-lookup 
     execution mode to a dynamic, thread-local stack-based lookup mode.
     This is a one-way only change, and cannot (currently) be reverted.
  1. This thread-local stack-based lookup mode allows any thread to create a
     stack of alternate values &ldquo;on top of&rdquo; the global definition.
     From within any thread of execution that has local `binding`s, only those
     local bindings are seen. The stack can be made larger by successive calls
     to `binding`, and the stack shrinks whenever a `binding` is exited. A
     dynamically bound value can be modified atomically without changing the
     stack size by atomically swapping the value at the top of the stack.
  1. Even once a `Var` has all bindings in all threads eliminated, it is still
     stuck in a slower, dynamic, thread-local mode of operation. This simplifies
     program execution (because otherwise, safely deciding when all threads have
     abandoned their stacks is quite challenging).

This is a lot to grasp, so some examples may be useful.


### Non-Dynamic Var Usage

Although this looks like a vanilla variable declaration in any programming
language, it actually creates an instance of `clojure.lang.Var`.

````clojure
user=> (def my-variable 5)
#'user/my-variable
````

`#'user/my-variable` is a bit deep. It means the following:

1. The fully qualified name of this variable is "user/my-variable". It
   means that the `Var` `my-variable` lives within the `user` namespace.
2. The `#'` prefix is a Clojure shorthand meaning that the &ldquo;value&rdquo;
   referenced is, in fact, the `Var` reference (the box containing the value 5),
   not the value itself (which is 5).


### Issuing Global Var Updates

Continuing the example above, we can atomically and globally swap the value
of `my-variable` by taking the existing `Var` and telling it to safely replace
the old value with the new one.

````clojure
user=> my-variable
5
;; inc is short for increment by 1
user=> (alter-var-root #'my-variable inc)
6
user=> my-variable
6
````

This update is global and atomic. Every thread sees the new value at the same time.

### Creating a Dynamic Var

If a Var is not marked as dynamic, it cannot be used for thread-local usage.
We can achieve dynamism simply by annotating the `Var` at declaration time:

````clojure
user=> (def ^:dynamic new-var 0)
#'user/new-var
````

In addition to being able to alter the root value of the `Var`, we may also
create thread-local bindings (entering the second mode of operation):

````clojure
;; We shadow the original definition, but the original is still there somewhere
user=> (binding [new-var new-var] (var-set #'new-var (inc new-var)) new-var)
1
user=> new-var
0
````

Within this thread-local context, we were able to (locally) replace one value
with another. Globally, however, the value stayed the same.

We cannot, however, attempt to call `var-set` or the like on the global `Var`
instance, because `var-set` and its ilk can only modify values at the top of
a non-empty stack of thread-local modifications.


## References

I learned quite a bit about this, but primarily by reading the source code of
Clojure. I'll compile a list of references below, all within the source of
`clojure.lang.Var`:

* [The official documentation on `Var` is helpful, but a bit terse.](https://clojure.org/reference/vars)
  My explanation is not strictly better than the official one, but provides
  more insight into the underlying data structures.
* [Clojure's `Var` uses `Frame` objects to store the state of the thread-local stack](https://github.com/clojure/clojure/blob/d7e92e5d71ca2cf4503165e551859207ba709ddf/src/jvm/clojure/lang/Var.java#L49-L74)
* [Clojure's `Var` has a property called `threadBound` which specifies mode of operation](https://github.com/clojure/clojure/blob/d7e92e5d71ca2cf4503165e551859207ba709ddf/src/jvm/clojure/lang/Var.java#L172-L178)
* [`Var` lookup speed is pretty quick, but using `dynamic` slows down lookups a bit](https://github.com/clojure/clojure/blob/d7e92e5d71ca2cf4503165e551859207ba709ddf/src/jvm/clojure/lang/Var.java#L190-L201)
* [Under the hood, `binding` pushes/pops thread-local stack frames](https://github.com/clojure/clojure/blob/d7e92e5d71ca2cf4503165e551859207ba709ddf/src/jvm/clojure/lang/Var.java#L314-L362)