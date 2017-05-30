+++
title = "Clojure Zippers Emulate Object-Oriented Programming?"
tags = ["programming", "clojure"]
date = "2015-11-05"
+++

Yesterday, I posted about using Clojure
[zippers](http://clojuredocs.org/clojure.zip/zipper)
to solve the problem of automatically generating a Table of Contents.
During my work with Clojure's implementation of zippers, I noticed something
interesting.

The `zipper` function creates (and returns) a new zipper object. Its parameters
are the following (lifted straight from the documentation):

1. `branch?` &ndash; a function that takes a node of the zipper and returns a
   true/false if it is capable of having children (even if it currently
   does not).
2. `children` &ndash; a function which, given a node in the zipper which is a
   branch, returns a `seq` (sequence) of its children.
3. `make-node` &ndash; a function which, given a node and a sequence of its
   children, returns a new branch node with the supplied children.
4. `root` &ndash; the root node of the data structure (which can also be
   any valid tree that the zipper to be constructed understands).

At first, this was a bit impenetrable. Why doesn't the zipper just know how
to zip over its data? How many types of zippers are there, exactly?

### Clojure: Hiding Objects in Plain Site?

After studying the source code, the truth came to light. The `zipper` function
is what a Java programmer might call a Factory function. It constructs valid
zipper "objects" (my words) to the specifications in the first three arguments
of the function by doing the following:

1. It creates a new 2-element vector and associates the tree to be zipped
   over  to the first element and the state of the object (whether it's
   modified, possible parent nodes, etc.) to the second element.
2. It attaches *metadata* to the vector, essentially hiding/storing the
   three specified functions on the vector.

All of the utility functions for manipulating zippers are then defined in terms
of the functions provided when constructing the zipper! They function by
extracting the embedded metadata from the zipper, using the necessary embedded
functions as needed, and then returning the manipulated zipper with the same
metadata included.

For example, the `append-child` function, which creates a new child node and
appends it to the current node, needs some knowledge of the type of node to
create. It gets that knowledge from provided `make-node` and `children`
functions:

1. It pulls those functions from the metadata
2. Appends the new item to the node's children using the `children` function
3. Calls the `make-node` function with the existing node and the appended
   children as its argument
4. Replaces the existing node in-place with one with updated children

In fact, the `make-node` function is itself a Factory function for creating
new nodes! All of the functions in the zipper namespace cohesively act like
what a Java programmer would call an Abstract Base Class, and the `zipper`
function creates anonymous instances of the "Zipper interface".

### Implications

Although Clojure is touted as a purely functional language with no
object-orientation (outside of its [protocols](http://clojure.org/protocols)),
the zipper class is an elegant example of being able to achieve clean
object-oriented design without even needing objects; The zipper object
is transparently manipulated by the "methods" defined during its creation.

### C Style Object-Orientedness

Actually, come to think of it, this is reminiscent of C-style "classes":
actually `struct`s which may contain functions (function pointers)
which perform operations over concrete instances of the "type". I don't
have much experience with C-style classes, so this seemed novel to me as I
was learning the API surface, but in hindsight, this is a classic pattern
in languages which have things remotely resembling first-class functions.
(Even C is more advanced than Java in this respect.)

## References

[The clojure.zip source code](https://github.com/clojure/clojure/blob/59b65669860a1f33825775494809e5d500c19c63/src/clj/clojure/zip.clj)
is interesting in that it was released with Clojure 1.0 over five years ago,
and has not had a single update since then! Powerful abstractions indeed.
