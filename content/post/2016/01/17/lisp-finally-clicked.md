+++
title = "Lisp Finally Clicked"
tags = ["clojure", "programming"]
date = "2016-01-17"
+++

I've been meaning to write this post for a couple of weeks now.
There is a story told among programming language enthusiasts that
programming as an art only &ldquo;clicks&rdquo; once a programmer understands
the Lisp programming language.
I finally feel like I've reached that point.
Although I don't think I'm an amazing
programmer, I finally feel like I understand the difference between
languages (like Python and Lisp), and why Lisp is often considered
so much more flexible
and powerful (at least in theory) than a language like Python or C.
(For reference, see any of Paul Graham's somewhat self-assured arguments
about Lisp. [I like his Blub essay the most.](http://www.paulgraham.com/avg.html)).

## Reserved Keywords vs. Provided Functions

Take, for example, a `for` loop in Python:

```` python
for x in range(10):
    yield x
````

In Python, `for` is implemented as a reserved word. That means that a
programmer cannot name a function or variable `for`. And although this is
reasonable in the case of `for`,
[there are actually 31 whole reserved keywords in Python 2 by my count](https://docs.python.org/2/reference/lexical_analysis.html#keywords)!
The implication of this is that any developer who wants to hack on the Python
language (by e.g. programatically rewriting Python source code)
needs to be wary of those 31 different restricted Python
symbols which cannot be customized at all. This challenge is further
complicated by how most of the keywords react with the other keywords in
complex ways.

* `break` interacts with looping constructs `for` and `while`
* `continue` interacts with looping constructs `for` and `while`
* `elif` can only follow an `if` block
* `else` can only follow an `if`, `try`, or `for` block
* `print` is a statement and not a function in Python 2
* `def` creates a function and binds it to a name. 
  It can be defined within any scope a variable can be assigned,
  and has interactions with `return` and `yield`
* `yield` permutes the enclosing function block to become a generator
  function, rather than a traditional function
* `return` will immediately exit any function scope it is nested within,
  including within `for` and `while` loops. However, `return` *cannot*
  be invoked at the top level of a file, because there is no valid enclosing
  function scope.

In general, it is nontrivial to rewrite programs 
in most programming languages
(which are not Lisps) because the keywords have
complex interactions and behavior. The only
real solution is to introduce a parser for
the language in question.

Compare Python's 27 keywords with the 15 or so keywords in Clojure
(many of which are targeted for Java interoperation)! The number of keywords
is less than half, and in fact, there are far fewer keyword interactions than
there would be in Python (or Java, C++, etc.). The essential keywords in
Clojure for defining the base of the language (excluding the Java interop bits)
are:

* `def` binds a value to a symbol
* `fn` creates a function
* `if` creates a ternary block
* `do` evaluates a sequence of forms
* `let` temporarily binds values to symbols in a scope
* `loop` is like `let` but also creates a point of recursion for use with 
  `recur`
* `recur` evaluates its forms and then attempts to jump back to the immediate
  enclosing `fn` or `loop` point

That's it. That's all it takes to define the language semantics of a Lisp.
Notice that 5 of the 7 special keywords in Clojure don't even care about the
other keywords. `loop` and `recur` have special semantics with each other, but
otherwise, there are far fewer global, arbitrary keywords to memorize.

How does a `for` loop look like in Clojure, then? See for yourself.

```` clojure
(for [x (range 10)]
  x)
````

Like with Python, `for` takes a sequence as its argument(s), in this case `x`.
It can be read as if it says &ldquo;for x in range 10&rdquo;, although it
doesn't read quite as fluently as Python tends to. However, note that unlike
Python, Clojure does not need to treat `for` as the beginning of a block, and
`for` does not require the presence of a reserved `in` keyword either.

In fact, unlike in Python,
[Clojure implements its `for` as a macro](https://github.com/clojure/clojure/blob/clojure-1.7.0/src/clj/clojure/core.clj#L4444-L4529)
which rewrites the sequence iteration as a recursive traversal, and accumulates
the results into an output. While Python's `for` keyword needs to be
implemented within the guts of the language, Clojure's `for` macro is provided
solely as a convenience: you could have written it yourself.

### Homoiconicity and You

The appeal of Lisp is that its program have the property of
[homoiconicity](https://en.wikipedia.org/wiki/Homoiconicity), which means that
Lisp program representations are structurally and semantically identical to
how Lisp code is literally structured.
(This is the farthest thing from the case in all other programming languages.
Interpreting/compiling other languages requires lexing words in the language
into tokens and then parsing the stream of tokens for meaning within the
context of the language.)

We can
ignore some of the more powerful implications of homoiconicity to start,
and only focus on the clean and simple interpretation.
All Lisp code looks the same; 
all Lisp code follows the same rules;
all Lisp code follows a predictable pattern.
Unlike in most languages, which have special magical keywords and
features (I'm looking at you, Python 
[list comprehensions](https://docs.python.org/2/tutorial/datastructures.html#list-comprehensions)), Lisp has nothing
fancy and needs nothing fancy: only parenthesis.
