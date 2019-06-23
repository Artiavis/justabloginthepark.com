+++
title = "Tiny Talk in Scheme"
date = "2019-06-02T18:07:26-04:00"
description = ""
tags = ["programming", "scheme"]
+++

A while back, I started tinkering with a new flavor of Lisp (for me):
[Scheme](https://en.wikipedia.org/wiki/Scheme_(programming_language)),
using the
[ChezScheme](https://cisco.github.io/ChezScheme/)
dialect.
A Scheme-compliant Lisp is one which (among some other bits) implements a faily
minimal set of functions/macros; simple string manipulations, data
structures and compound data types, basic math and I/O,
and a fairly sophisticated function definition, error handling, and hygienic macro facility
(a full summary of the language spec can be found [here](https://www.scheme.com/tspl4/summary.html#./summary:h0)).
I chose Chez Scheme because of its fascinating heritage as an industrial-strengh
production-ready Scheme dialect, and because it seemed more traditional (being fully self-hosted);
but that's a conversation for another post.

As a minimal Lisp, Scheme has only a primitive "object" system
(if you can even call it that): [records](https://www.scheme.com/tspl4/records.html#./records:s13),
which are roughly analogous to `struct`s in C.
For example, a tree-node structure from the worked examples in
[The Scheme Programming Language Version 4](https://www.scheme.com/tspl4/examples.html#./examples:h4),
produces a structure not unlike one which would be used in Java.

````scheme
(define-record-type tnode
  (fields (immutable word)
          (mutable left)
          (mutable right)
          (mutable count))
  (protocol
    (lambda (new)
      (lambda (word)
        (new word '() '() 1)))))
````

The `define-record-type` macro generates (in this case) a custom constructor of a single parameter,
a predicate for testing whether objects are instances of `tnode`,
and both [getters/setters](https://en.wikipedia.org/wiki/Mutator_method)
(the setters by default are the getters with the suffix `-set!`):

* `make-tnode`
* `tnode?`
* `tnode-word`
* `tnode-left`
* `tnode-left-set!`
* `tnode-right`
* `tnode-right-set!`
* `tnode-count`
* `tnode-count-set!`

Scheme intentionally does not include a particular implementation of a
[object-oriented programming paradigm](https://en.wikipedia.org/wiki/Object-oriented_programming)
(classes),
preferring to let programmers roll their own.
Now, I don't think I can invent a novel or particularly interesting
object-oriented programming system; but I do find it fascinating to study
how others have done it.

Typically, objects are at least somewhat self-aware
(ie it is possible to ask an object for its type, and usually also to
ask an object whether it conforms to some type).
[Prototypical inheritance](https://en.wikipedia.org/wiki/Prototype-based_programming)
affords one of the simpler ways to devise
an object system, especially for dynamically typed programming
languages, for a few reasons:

1. Objects can be built using only one data structure: the all-powerful dictionary.
1. Instances of objects, and object prototypes, do not need to be differentiated.
   Prototypes are typically objects with associated code but no data; instances
   are typically objects with associated data but no code; but there is no firm
   requirement to make this distinction.
1. Combining objects is as simple as including them in the delegation chain
   of another object.

One such neat system I've recently stumbled upon is
"[TinyTalk](https://launchpad.net/kend)",
a minimal Smalltalk-like prototype-based object system,
developed by Ken Dickey as a spiritual successor
to his Yet-Another-Simple-Object-System (YASOS)
system.
(For those of you unfamiliar with Smalltalk, think JavaScript, but more consistent.)
It defines a full object-oriented system in under 400 lines-of-code!

In JavaScript, one might define a "Point" class as:

````javascript
var Point = (function() {
  function Point(x, y) {
    this.x = x;
    this.y = y;
  }
  Point.prototype.distanceBetween = function(other) {
    if (Point !== other.constructor) {
      throw new Error("Need two points!");
    }
    var dx = this.x - other.x;
    var dy = this.y - other.y;
    return Math.sqrt(dx * dx + dy * dy);
  }
  Point.prototype.isEqualTo = function(other) {
    if (Point !== other.constructor) {
      throw new Error("Need two points!");
    }
    return this.x === other.x && this.y === other.y;
  }
  return Point;
}());
````

In this case, `Point` is both the name of the type, as well as the factory-function
with which to produce instances. However, there isn't really a `Point` class, so
much as an anonymous `Point` object which contains both the constructor and function
definitions. Per the convention described above, data are stored on the object itself
(`this.x = x`), but the code is stored on the object's prototype
(`Point.prototype.distanceBetween = ...`).
And, due to historical baggage, JavaScript class factories generally share a name
with their types, and are invoked by calling the `new` operator on a particular
prototype.

In TinyTalk, something equivalent looks like:

````scheme
(define proto-point
  (object () ;; Methods only
    [(point? self) #t]
    [(distance-between self other)
      (unless (point? other)
        (error "Needs two points!"))
      (let ((dx (- [$ x self] [$ x other]))
            (dy (- [$ y self] [$ y other])))
        (sqrt (+ (* dx dx) (* dy dy))))]
    [(=? self other)
      (unless (point? other)
        (error "Needs two points!"))
      (and (= [$ x self] [$ x other]) (= [$ y self] [$ y other]))]))

(define (new-point x y)
  (object
    ([x x] [y y]) ;; Each instance has its own data...
    [(delegate self) proto-point])) ;; but shares code...
````

Here, `new-point` is the factory-function for creating instances.
TinyTalk names its prototype lookup `delegate` instead of `prototype`,
although it is functionally identical.

Of course, prototypes have other fun capabilities, such as dynamic
extension. Because objects are backed by the dictionary data structure,
adding new functionality to an existing prototype or object is as simple
as adding a new entry into the appropriate dictionary.

````scheme
($ add-method! proto-point '->string
  (lambda (self)
    (string-append
      "(point "
      (->string [$ x self])
      " "
      (->string [$ y self])
      ")")))
````

## Objects all the way... up?

Now, in a typical programming environment which supports classes, _all_
objects should strive to conform to the class system. How does TinyTalk
manage to do this for e.g. ChezScheme, whose built-in data structures like
lists and vectors exist outside the object system?

The answer is both clever and either satisfying or ugly
(depending on your taste). TinyTalk includes a dynamic "escape hatch" for its
type system, to allow retrofitting the rest of the Scheme types with the
object system. Unlike typical TinyTalk objects, whose code lives exclusively
inside their self-contained prototype chain, the built-in types can be given
"global" prototypes.

TinyTalk contains a global getter/setter called `custom-method-finder`, which
is included in the delegation chain for _all_ TinyTalk objects. By default
it is always disabled, running and built-in types do not have prototypes.

However, TinyTalk also ships with a module named `tiny-talk-plus.sls`, which
activates the `custom-method-finder` and binds it to a global dictionary.
This global dictionary leverages the Scheme
built-in type-types (e.g. `(list? (list))` returns true).
Virtual prototypes are created for the built in types, and
added to the global dictionary. Whenever an unknown object is invoked,
not only is that object's own prototype consulted (when it exists), but the
dictionary is, too.

## When would I use this?

That's a good question! Most of the time, when I do personal programming,
I'm using a language like Python/Clojure, which already has a robust
object system built in.
(Python's object system is essentially prototype-based, whereas Clojure's
has prototype-like flexibility but isn't actually prototype-based.)

I suppose that _if_ I were writing a video game from scratch,
_and_ I was also writing the engine from scratch,
_and_ I was going to embed an engine (that wasn't Lua),
I could use ChezScheme with TinyTalk to do so.
But even if I don't do that, it's nice to know that it's there.
