+++
title = "Pros and Cons of Clojure"
tags = ["programming", "clojure"]
date = "2015-10-18"
+++

As part of my forays in interesting (and generally unusable at work)
programming languages, I began investigating 
[Clojure](clojure.org) back in June. Although I really love the
language as a whole (and, in fact, I'm using it to power this blog!),
I struggled not only to set it up, but to find its ideal niche.
This essay/rant is a result of a conversation I had about Clojure with
two friends, one who is an excellent polyglot programmer, and one
who is a beginner simply interested in Clojure as a practical Lisp.

## Strengths of Clojure as a Language

I have to hand it to Rich Hickey &mdash; Clojure is a brilliant and well-designed
language. This is in no small part due to the power of Lisp and its ability
to incorporate almost anything as part of the language, but is also helped by
Rich's insistence on not simply chucking half-baked features into the language.
A brilliant example of this (I'm unsure whether this is native to Lisps or
simply a Clojure implementation detail) is that keys to maps double as functions
for retrieving the corresponding values from maps (and vice versa).

### Multiparadigm

Lisp is leveraged to great effect not only in flexibly implementing the core
language, but also in implementing language constructs borrowed from other languages.
Clojure borrows actors from Erlang, Go routines from Go,
and logic programming from Prolog. It's possible to cover many of the language
features of those languages (and probably new ones) without ever needing
to leave Clojure land.


### Functional Programming Constructs

Lately, functional programming has been experiencing an increase in popularity
as technologies like [React.js](https://facebook.github.io/react/)
highlight the power of not mutating state in long-running applications.
Although Object Oriented Programming is a robust and clever solution to
a certain class of problems, it often struggles and can be unnatural in others.
In fact, I recently read a blog post (which I can't seem to find anymore)
which I believe explains this point nicely (paraphrased from memory):

> In programming, there are certain intrinsically stateful "entities", which are
  reasonable to represent using objects: databases and files, for example.
  At any point in time, the state of these entities can be almost anything,
  and they are not fixed even during the lifetime of a program,
  so it's reasonable to represent them as stateful objects.

> However, most things in programming are *not* stateful entities.
  Objects are often just glorified maps with simple operations defined upon
  them, which have no need for or significant gain from intrinsic state.
  Anything which isn't a complex entity, such as a list or map or string,
  almost definitely need not be represented using objects, and should instead
  be represented using "pure" data types.

> In general, a program may only need to interact with one or two entities
  but will probably need to interact with many thousands of data types.
  For a domain with need of few entities but many pieces of data, does it make
  more sense to choose a paradigm which favors data, or entities?

Clojure builds on the functional programming nature of languages like 
Haskell by having variables be immutable by default, as part of the core
language runtime. It's beautiful that the persistent collections are built
into the language and impossible to violate or contaminate.


## Strengths of Clojure from the JVM

As a dynamically typed language, Clojure shares the same blazing
speed of rapid prototyping as Python. But as a JVM-based language,
Clojure manages to be relatively performant (even with persistent collections)!

Clojure also manages to piggyback on the existing ecosystem of Java tools rather well. Clojure can run almost any Java library using its language interop features.
It has the same JAR-based deployment model, which can be as simple as copying
a file to a server and running code. (Compared to Python, this is far easier!)
And perhaps best of all, Clojure can leverage the Google Closure Compiler
to compile code into JavaScript
([ClojureScript](https://github.com/clojure/clojurescript/wiki))!

## Weaknesses of Clojure as a Language

Although the Clojure language is *usually* beautiful, that beauty unfortunately
is not present everywhere.

### Primitive Types are Still Java Primitives

Although Clojure promises to be a high level abstraction over the Java language, where interop features should only be
needed for libraries, the truth is that even nuts and bolts of the language occasionally require dropping down to Java.
My sticking point is that in order to convert the string "5" to the integer 5, I need to call the Java Integer class's
"parseInt" method, which is essentially an interop call.

```clojure
(defn parse-int
  "I need to call to a static method on the Integer class
  in order to cast an integer to a string!"
  [int]
  (Integer/parseInt int))
```

Although I understand that Clojure is built above the JVM and primitives
can't be completely wrapped by the Clojure runtime without suffering
performance penalties, it's still a jarring compromise.

### Wrapping Exceptions

Exceptions and Exceptional handling aren't meant to be done in Clojure (think C style "codes" signifying error
conditions) itself, and Clojure has reasonable ways of handling these things. However, in practice much of writing
Clojure requires wrapping Java libraries which do make heavy use of this feature, and in particular anyone writing a
production-ready Clojure app needs to make sure every conceivable Exception does get caught to ensure horrifying stack
traces don't get spilled to users. As a result, people writing production Clojure code (presumably its target use case?)
must still get down and dirty by writing lots of messy Exception handling code in a (functional) language whose paradigm
was never meant to support them.


### Stack Traces

This is a bit of a funny issue. Generally, you hope to never see a stack
trace from a program, as it is a worst-case scenario for code execution.
On the other hand, they're generally unavoidable, making this problem even
more frustration. 

Because Clojure is an **interpreted** language **built above another runtime**,
a crashing Clojure program will necessarily spill a (very large) Java stack trace.
This is both aesthetically unpleasing and practically a tough thing to debug,
as it can be difficult to ascertain whether the cause of the crash was a Clojure
problem or a Java problem.

## Challenge of the Learning Curve

Let's be frank here and admit that Clojure has one of the highest learning curves
of any programming language. But it's not for the reason one typically expects,
that the language itself has a conceptually complex set of rules
like Haskell or Rust
(although persistent collections take a while to grasp).
Rather, simply getting a fully functioning Clojure installation and editing
environment can be extremely frustrating. 

### Editor

The ideal Clojure development model
is so-called &ldquo;REPL-based development&rdquo; &mdash;: writing all code in
an editor which is connected to a live interactive Clojure session, and
&ldquo;sending&rdquo; chunks of code into the session for evaluation.
(For those who haven't done this in languages like Ruby or Python, it's
incredibly powerful and far more useful than debugging for piecing out programs.)

The only editor which supports this model (and Clojure itself) out of the box
is [Light Table](http://lighttable.com/), essentially a working prototype
of a REPL-based editor. However, Light Table is only really preferable for
Clojure, because every other language has a generally superior editor available.
In order for someone to get up to speed in Clojure, they need to first learn
the language in Light Table. However, Light Table isn't generally scalable
to large projects due to its small ecosystem of plugins.
Once a Clojure student is ready for the next step,
they must bite off the huge task of learning a text editor or IDE
and all its plugins and configure them all at once to get an even barely
functional environment.

### Paredit

Anyone with experience in a Lisp will tell you that 
[Paredit](http://emacswiki.org/emacs/ParEdit) is the only sane way to do
serious Lisp programming. (Paredit is a family of text-manipulation shortcuts
for manipulating Lisp-based languages.) Other languages generally
use blocks and indentations naturally during coding, such that one or more lines of code
can be seamlessly moved up or down to allow manipulating code. Due to Lisp's
favored style of code structuring, it's impossible to do this with Lisp code.
One has to manually copy and paste code until one is ready to bite the bullet
and invest in learning Paredit (which, as mentioned above, requires a "big boy"
editor).

## Weaknesses of Clojure as a Tool of Choice

### Initialization Time

Despite its beauty as a language, Clojure isn't ideal for certain tasks
like command-line utilities and short scripts.
The cost of bootstrapping both the JVM and the Clojure runtime make it
so that even relatively short programs which take milliseconds to run
still need one or two seconds to initialize. (Generally, my quick and dirty
Python programs run and return before I can even blink.)

### Lack of Explicit Types Come Back with a Vengeance

Like other dynamic languages (e.g. Python), the same lack of explicit and static typing that makes prototyping seem
faster and easier also makes getting guarantees about types more difficult, eventually requiring an order of magnitude
more unit tests which simply sanity check types of arguments.
Although Clojure has projects like 
[Typed Clojure](https://github.com/clojure/core.typed)
and 
[Prismatic](https://github.com/Prismatic/schema),
which aim to help, they aren't quite the same as having types built into the language when it comes to refactoring.

### Ecosystem Still Isn't at Critical Mass

Although this is probably a topic for another post, it's generally understood that
a programming language doesn't exist in a vacuum. In order to achieve mainstream
popularity, a language needs not only approachability and ease of learning,
but also a healthy and vibrant ecosystem of users available to help, libraries
for common tasks, and frameworks for common applications: mindshare. Even if a language were
trivial, the lack of a strong ecosystem can prevent a language from ever being
feasible. Most developers don't have the luxury of getting to reinvent the wheel
in their language of choice, so having an army of tried and true libraries for
routine tasks is imperative to succeed.

While Clojure has a good number of libraries, benefiting in particular here from
its ability to leverage Java for low-level features, it still doesn't feel like
there is a plethora of fully fleshed out Clojure libraries in late 2015.
Clojure simply doesn't have the number of libraries that Java, Python, Ruby,
or even (especially?) JavaScript each have.

This makes Clojure risky to develop serious projects with. Without the library
ecosystem, who can be sure that there will be fresh new developers coming in
to develop new projects and grow or maintain existing ones? At the end of the day,
why should a Java developer learn Clojure over Python when one has a much,
much larger ecosystem and mindshare?


## Overall Sentiments

I strongly feel that Clojure is a brilliant programming language which more than
makes up for its occasional Java warts. Any time I may want to use Java,
I could probably also make use of Clojure 
([except for Android](http://blog.ndk.io/2015/04/23/state-of-coa.html)).

However, I would still be concerned about starting a new Clojure project in a
professional environment. I just don't think Clojure is &ldquo;shiny&rdquo;
enough or commercially appealing enough to incentivize newcomers to roll the
dice on it when a company or project is on the line, and I don't think the
library ecosystem is currently strong enough to confidently bet a project
on the right libraries existing.

If a beginner asked me whether learning Clojure is a good professional investment in 2015,
I'd have to tell them no. I can't, in good conscience, condone a language
that I feel has limited industrial applications for the aforementioned reason.
This doesn't even take into account the learning curve!

Clojure will probably be a hobby language for me; I don't expect to be fortunate
enough to use it professionally any time soon.
