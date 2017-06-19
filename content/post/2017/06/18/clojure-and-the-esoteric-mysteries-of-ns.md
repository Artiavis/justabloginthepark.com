+++
date = "2017-06-18T13:12:46-04:00"
description = "Wherein I discuss some of the interesting aspects of how Clojure achieves its namespace concepts, which are (to a large extent) a figment of the compiler's imagination."
tags = ["programming", "clojure"]
title = "Clojure and the Esoteric Mysteries of Namespaces"
+++

I recently had the drive/opportunity to deep-dive on how Clojure's namespaces
function and how they provide a simple abstraction using the concept of Clojure's
&ldquo;`Var`s&rdquo;. Here is a deep-dive on how they work. This is a two-part
series. 
The previous part of the series is available at
[Clojure and the Esoteric Mysteries of Vars]({{<relref "clojure-and-the-esoteric-mysteries-of-vars.md">}}).

A a fair warning, this requires a far bit of gory Clojure compiler internals to
really understand. I'm going to attempt to walk through the relevant bits, but
it may not make much sense without also reading the relevant portions of source
code. Thankfully, Lisps are simple to understand, so it should only take a few
hours (instead of days or weeks).

## What's in a Name?

Since the earliest days of Computer Science, programmers have struggled with
confining subsets of their routines into global compartments, to both minimize
the cognitive load of juggling a multitude of routines and variable names, as
well as to differentiate between public and private routines (API's). Of course,
to a certain extent, these distinctions are indistinct to a computer.

* In binary or assembly languages, all symbols are global and essentially public.
* In C, which is itself a low-level abstraction over common computer hardware
  (but without requiring writing to specific CPU instructions), all variables
  and routines are still essentially global. There is, however, a limited concept of
  privacy in that a library developer need only expose certain routines and
  data structures.

Since then, different approaches have been taken to try and tackle the concept
of compartmentalizing units of code. C++ bolted-on namespaces a few year after
its release, but they are primarily oriented towards avoiding a global quagmire of
potentially-conflicting names. (During compilation all namespace distinctions
are essentially erased). Java (and I assume C#) have something similar to
namespaces in that &ldquo;packages&rdquo; uniquely and globally distinguish names
(similarly to C++). Although Java itself does not provide an easy facility for
first-class manipulation of namespaces, [there are ways of discovering things about them](https://stackoverflow.com/questions/520328/can-you-find-all-classes-in-a-package-using-reflection).
This is not the same as the language/platform itself providing that facility.

Clojure (and languages like it) provide first-class namespace support. There
are two distinct aspects to namespaces in Clojure:

1. Namespaces are globally-available Clojure objects which both contain as well
   as name public (as well as private) objects.
   Accessing a Clojure namespace is as simple as requesting it
   from the runtime. There is not necessarily any relationship between Clojure
   namespaces and files of Clojure source code, although for practical purposes
   they're usually kept one-to-one.
1. Namespaces, in particular through the &ldquo;current&rdquo; namespace, are
   used to write programs without fully qualifying references. When the compiler
   sees references which are not fully-qualified, it will fall back upon the
   &ldquo;current&rdquo; namespace to resolve fully-qualified `Var` references.
   This (like in other languages e.g. Java/C++) is not a strict necessity, but
   it is ubiquitous in practice, and has some startling implications due to
   Clojure's highly dynamic nature.

## Namespaces as Maps

At its simplest, namespaces are global lookup-maps within Clojure's runtime
which provide a level of indirection similar to that of a filesystem:

* Namespaces operate as maps of namespace-names to namespace-objects. The names
  just uniquely identify the namespace objects.
* Namespace objects are containers for mapping names of `Var`s to `Var`s. The
  indicated `Var` instances need not always be stored in the namespace from
  which they are found; it is common to _alias_ some `Var` objects from multiple
  namespaces, especially the functions from within `clojure.core` (which is the
  core library of Clojure).

Much like a filesystem can have multiple distinct fully-qualified filenames which
ultimately reference the same files through the use of symbolic links, Clojure
allows aliases such that multiple fully-qualified references name the same `Var`.
Unlike file systems, Clojure `Var` objects generally know within which namespace
they were originally bound.

To borrow my samples from the previous article, let's create a `Var` named
`my-variable` within the `user` namespace.

````clojure
user=> (def my-variable 5)
#'user/my-variable
````

The fully qualified name for this `Var` is `#'user/my-variable`, which I previously
explained means that the `Var` knows it is named `my-variable` and that it is
rooted in the `user` namespace.

If we were to then switch namespaces and reference the variable,
the reference would become locally available in an unqualified manner:

````clojure
user=> (ns 'other-ns)
nil
other-ns=> (refer 'user :only '[my-variable])
nil
other-ns=> user/my-variable
5
other-ns=> my-variable
5
other-ns=> #'my-variable
#'user/my-variable
````

We do not need the fully-qualified name if we choose to omit it (and in fact
this can enable certain programming patterns by dynamically replacing certain 
utilities with wrappers for convenience/performance). As already described, the
`Var` is not fooled &ndash; it knows where it is bound.
(Compare this to, say, Python, which does *not* know where variables actually
live, and in which is not conventionally possible to globally change the
definition of all uses of a certain import retroactively.)

## Namespaces as Compilation Contexts

It is traditional in most programming languages which support local references
to omit the fully (namespace) qualified names for variables. As indicated above,
one would omit the fully qualified name `user/my-variable` and instead simply use
`my-variable` in scope. For performance reasons, however, Clojure does not look
up the reference to a `Var` every single time a function is called or a variable
is referenced. Instead, generally speaking, whenever *any* Clojure code is
defined, all unqualified references will be resolved to their fully-qualified
references, and those references will be embedded into the compiled code. In
this way, a program can change the root `binding` using the already-discussed
`alter-var-root` function and it will be seen globally by all code using that
`Var`, because the references are fully-resolved by the compiler when parsing
code. How does this occur?

### Compilation as Batched Code Definitions

Within any Lisp, not just Clojure, the distinction between code which is
compiled in advance of program execution, and code which is interpreted (and
then compiled) on the fly, is blurry at best. These runtimes typically bootstrap
a core language implementation and then successively load and compile units of
code until an entire program has been defined; these runtimes are then coerced
to dump a copy of their working memory to some sort of file
([see `unexec` for Emacs/Emacs Lisp](https://lwn.net/Articles/673724/)
or [images for Smalltalk](https://stackoverflow.com/questions/3561145/what-is-a-smalltalk-image)).
Indeed, the fundamental property
of systems like Lisps and Smalltalk (which was inspired by Lisp) is that the
&ldquo;final&rdquo; program is one where it is no longer necessary to define
additional routines. As such, some programs (\*cough\* Emacs) are _never_
considered finished, because more functionality can be added in at any time.

Thus, the process of adding new functionality (code) to a Lisp (in this case
Clojure) is _mostly_ indistinguishable from compiling code in advance, and
restoring the compiled code ex-post facto.

### Code Loading Occurs Within Namespaces

We already discussed above that all `Var`s live within namespaces. How does
Clojure decide into which namespace to assign a newly defined `Var`? Although
the machinery is available such that a programmer can attempt to directly create and
intern a `Var` into an arbitrary namespace, it is far more common to simply
create unspecified &ldquo;definitions&rdquo; which default to the current
namespace. When authoring Clojure source code, developers will create new
namespaces and add functionality into them until complete, and then repeat:

1. Enter a namespace and import the relevant Clojure machinery. This is typically
   done in source code using the `ns` macro, which creates and enters that
   namespace, and then optionally does things like copy `Var`s from other
   namespaces into the current namespace. (As already discussed, there's not
   too much overhead from this, because all the references point to the same `Var`
   object.)
1. Declare and define functions and objects, without explicitly declaring the
   namespace. The namespace within which the definitions occur magically becomes
   the namespace within which those variables are interned.

## What is the &ldquo;Current Namespace&rdquo;?

Ay, there's the rub! The current namespace in Clojure is stored in the `Var`
&ldquo;`#'clojure.core/*ns*`&rdquo;. (The book-ended asterisks in Clojure are
called &ldquo;earmuffs&rdquo;, and imply (but do not promise) that the thusly-named
`Var` is dynamic.) As already discussed, `Var`s usually have a single, global
root, and can optionally have thread-local bindings. When the current namespace
is changed through the use of the `ns` macro or the `in-ns` function, the value
of `*ns*` is altered. Is this done by swapping the `Var` root, or by changing a
thread-local binding?

To answer this question, I had to dive deep into the source code for the Clojure
runtime (which is distinct from the `clojure.core` library, although `clojure.core`
surfaces _most_ of the runtime through public API's). Let's take a tour.

### Bootstrapping the Clojure Runtime

First, let's poke around the Clojure runtime (which is written in Java for the
canonical implementation). Looking 
[in the initial declarations](https://github.com/clojure/clojure/blob/42a7fd42cfae973d2af16d4bed40c7594574b58b/src/jvm/clojure/lang/RT.java#L221-L222)
of `clojure.lang.RT`, we see that `*ns*` is _secretly_ defined in Java and
declared as dynamic `Var`. It _also_ happens to have a default value of
`clojure.core`. This means that the global root of `*ns*` everywhere is really
`clojure.core`. But how do we enter new namespaces if `*ns*` is globally
`clojure.core`?

Enter `in-ns`, the Clojure function which changes the current namespace, `*ns*`.
[The source for this function is just a few lines further down in the same file!](https://github.com/clojure/clojure/blob/42a7fd42cfae973d2af16d4bed40c7594574b58b/src/jvm/clojure/lang/RT.java#L231-L244)
`in-ns` in Clojure is really a `Var` (not dynamic) in Java which references the
Java function `inNamespace`, which in turn calls `.set(ns)` on the `CURRENT_NS` `Var`.
To see how this works, we must read the source in turn for `Var` in
`clojure.lang.Var`.

### How Does Setting a Var Work?

Calling `.set(...)` on a `Var` happens
[here](https://github.com/clojure/clojure/blob/d7e92e5d71ca2cf4503165e551859207ba709ddf/src/jvm/clojure/lang/Var.java#L214-L224).
This function checks for a &ldquo;thread binding&rdquo; and throws an exception
if one cannot be found. The thread binding is defined
[here](https://github.com/clojure/clojure/blob/d7e92e5d71ca2cf4503165e551859207ba709ddf/src/jvm/clojure/lang/Var.java#L354-L362)
and
[here](https://github.com/clojure/clojure/blob/d7e92e5d71ca2cf4503165e551859207ba709ddf/src/jvm/clojure/lang/Var.java#L172-L178)
and
[here](https://github.com/clojure/clojure/blob/d7e92e5d71ca2cf4503165e551859207ba709ddf/src/jvm/clojure/lang/Var.java#L314-L328).
What this essentially says is, &ldquo;If and only if a thread-local binding
already exists for this variable in the current thread, perform the set operation,
otherwise you are attempting to make a thread-local modification to a global
`Var` and that's forbidden so have an exception.&rdquo;

### The Current Namespace is a Phantasm

This is where things get to be a bit head-spinning, but also very cool and
powerful. _The current namespace, at least globally, is always just `clojure.core`_!
(Of course you could monkey with the root binding of the `Var`, but I would not
recommend that, given this information.) 
Whenever a Clojure source program claims to be changing the namespace, it's really just
_changing the current namespace within the current thread of execution of the program!_.
In other words, the current namespace is illusory, a convenient fiction maintained
by large parts of the Clojure runtime for expedience and convenience.

&ldquo;How has the wool been pulled over our eyes this entire time!?&rdquo; you
and I both ask. In order for this to happen, everywhere we might have believed
that we were changing the namespace globally, we must have only been permuting
it within a single thread. The two main places this illusion arises are:

1. During REPL use.
1. During compilation.

I will show that in both of these locations, the Clojure runtime actually creates
a thread-local `binding` for `*ns*`, effectively isolating the global namespace
for the purpose of defining new code.

## The Clojure REPL Binds the Namespace

There's not much to say here. The relevant lines of the Clojure REPl source code
[are defined here](https://github.com/clojure/clojure/blob/e3c4d2e8c7538cfda40accd5c410a584495cb357/src/clj/clojure/main.clj#L65-L89).
The interactive Read-Evaluate-Print-Loop with which we are so familiar is actually
concealing a thread-local binding (override) to `*ns*` under the hood. Because
the binding underpins the entire REPL, within the REPL one could be forgiven for
thinking that the current namespace actually exists. In reality,
_it exists only within that thread_. It's fairly uncommon to start spawning off
new threads from the REPL which attempt to read the current namespace, so this
could easily be missed.
[Here's a nice counterexample showing that the current namespace is not as real as you might think.](https://cemerick.com/2009/11/03/be-mindful-of-clojures-binding/)

## The Clojure Compiler Binds the Namespace

I'll be honest, I'm not yet quite adept at reading compiler source code, even 
for a Lisp. However, it's fairly easy to spot what we're looking for, now that
we know what that is.
[Compilation happens inside this large `compile` function](https://github.com/clojure/clojure/blob/f2987665d00a579bf4efb169cf86ed141e0c1106/src/jvm/clojure/lang/Compiler.java#L7561-L7724).
Notice that, at the top of the function, it creates a thread-local binding for
`#'clojure.core/*ns*`, based on the current value. (Tracking exactly where in the
compiler it _evaluates_ the `in-ns` function is a bit tricky. It appears to do
that while it's parsing and emitting bytecode, but I haven't gotten that far into
the code base.)

## Implications

The fact that the machinery for creating namespaces, defining `Var`s, and sticking
those `Var`s inside namespaces uses thread-local bindings means that, for the most
part, Clojure code can be added at runtime from any number of threads, relatively
safety. (Relatively is the operative term &ndash; if different threads are trying to
load data with the same name, and set them as root bindings, trampling can and
probably will still occur.
See [this ancient thread with Rich Hickey about the lack of safety of changing root bindings dynamically](https://groups.google.com/forum/#!topic/clojure/b3DB23nJ7h8).)

Although this may seem strange, it's actually quite liberating. There is nothing
particularly special about the Clojure compiler or REPL; they just happen to have
the local bindings set up correctly. If you need to do runtime code loading (via
`eval` or the like), you could similarly set up new namespaces for that code.
(Technically Clojure does not guard against malicious actors, so custom classloaders
may be needed if you're loading code from an untrusted party.)

## References

* [The official documentation on namespaces](https://clojure.org/reference/namespaces).
  I'm actually less of a fan of this document than I was of the `Var` document,
  because it doesn't address potential corner-cases with the `*ns*` `Var` that
  I highlighted above (which is admittedly an uncommon use case).
* As mentioned in the previous article, [the official documentation on `Var` is helpful, but a bit terse.](https://clojure.org/reference/vars)
  `Var`s and namespaces go hand in hand, so don't be afraid to refresh yourself
  on their function/purpose.
* [`clojure.lang.Namespace`](https://github.com/clojure/clojure/blob/d7e92e5d71ca2cf4503165e551859207ba709ddf/src/jvm/clojure/lang/Namespace.java)
* [`clojure.lang.RT`](https://github.com/clojure/clojure/blob/42a7fd42cfae973d2af16d4bed40c7594574b58b/src/jvm/clojure/lang/RT.java)
* [`clojure.lang.Compiler`](https://github.com/clojure/clojure/blob/f2987665d00a579bf4efb169cf86ed141e0c1106/src/jvm/clojure/lang/Compiler.java)