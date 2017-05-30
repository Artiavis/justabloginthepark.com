+++
title = "F Sharp vs Clojure Toy Problem Shootout"
tags = ["programming", "clojure", "f-sharp"]
date = "2015-10-28"
description = "I perform a coding exercise in both Clojure and F# and compare the experience and code between the two versions."
+++

As a continuation of my forays in interesting and less industrially-oriented
programming languages, I decided to compare
[F Sharp](fsharp.org)
against [Clojure](clojure.org) for a relatively simple programming
problem, and to compare how the two felt in terms of programming ease,
friendliness, and how they each viewed the problem.


## The Problem

The problem is a relatively one from
[Reddit's &ldquo;Daily Programmer&rdquo; subreddit](https://reddit.com/r/dailyprogrammer), called
[JSON Treasure Hunt](https://www.reddit.com/r/dailyprogrammer/comments/3j3pvm/20150831_challenge_230_easy_json_treasure_hunt/):
given a random, unstructured JSON object, traverse the object looking for
a specific terminal value (in this case, a string "dailyprogrammer").
This is, of course, an unstructured tree traversal question.

Anyone who's taken a basic data structures or algorithms course can immediately
recognize that this problem lends itself naturally to a recursive solution.
(Of course, it's possible to traverse trees using stacks or queues, but where's
the fun in that?)

What makes this problem interesting is that the tree, as valid JSON, can
be of any JSON type:

* a number (whether integers are supported is language-specific, but both
  of our languages in question do support integers)
* a string
* a boolean (true/false)
* null
* a list of any valid JSON type
* an object mapping any of the first four types to any valid JSON type

Because the JSON is unstructured, it's not possible to know the types of each
value in advance, other than that it can be any of these. Therefore, we ideally
need a recursive way to dispatch based upon type.

There is a minor complication here because we need to maintain a path to the specific value in question.
**This is tricky because the path can consist of both strings and integers**:

* Any object on the way to the specified value is generally keyed by a string
* Any array on the way to the specified value is keyed by an integer

We will need a return type that can represent both strings and integers in
a collection seamlessly.

## F Sharp Solution

Although I didn't write the F Sharp solution until after I had already written
the Clojure solution, I actually found it easier to model this problem using
F Sharp's native data types. Therefore, I'll begin with my treatment of F Sharp.

When I first saw this problem, I immediately thought of how I could represent
it in a typed language like F Sharp. F Sharp, like other statically typed
functional languages, supports
[discriminated unions](http://fsharpforfunandprofit.com/posts/discriminated-unions/),
which allow flexibility of typing in a constrained and deterministic manner.
As it happens, the
[F Sharp Data](http://fsharp.github.io/FSharp.Data/library/JsonValue.html)
[library already implements this type](https://github.com/fsharp/FSharp.Data/blob/0ea9937903d26004322b3fc6f29863e721985b1a/src/Json/JsonValue.fs#L34-L41).

Given a compound type for each of the valid JSON types, I can
[pattern match](http://fsharpforfunandprofit.com/posts/match-expression/)
each of the types in turn to ensure that every type of JSON data is
handled appropriately.

To solve the earlier problem of needing to represent both strings and integers
in our return type (our solution), we can write our own simple union type:

```fsharp
type TreasurePathCrumb =
    | Index of int
    | Key of string
```

This crumb type will help us remember the path to the specified value
(although, since this is a recursive solution, it technically would be more
accurate to say it will help us to remember the path *from* the specified
value).

Now, once we find the value in question, we can simply begin returning values
by wrapping them in this union type. When we've captured the sequence of union
types in our main function, we can just unpack them and convert them to strings:

```fsharp
let buildTreasurePathString (path:TreasurePathCrumb list) = 
    let crumbToString crumb = 
        match crumb with
        | TreasurePathCrumb.Index i -> string i
        | TreasurePathCrumb.Key k -> k
    let stringCrumbs = List.map crumbToString path
    stringCrumbs |> String.concat " -> "
```

This function preserves strings while converting the integers to strings,
so that we can cleanly concatenate all the values at once.
(I'm not fluent in F#, so this may be completely unnecessary, but it's
also a pleasure how straightforward this is to do!)

However, there's still one unresolved type question: what do we do when we
don't find a value? This is obviously going to be happening far more often than
finding the specified value.

As it happens, F# (and its brethren) have an answer to this as well:
[the Option type](http://fsharpforfunandprofit.com/posts/the-option-type/):

```fsharp
// Taken from http://fsharpforfunandprofit.com/posts/the-option-type/
type Option<'a> =       // use a generic definition  
   | Some of 'a           // valid value
   | None                 // missing
```

An option type responsibly answers the question, "What if there is not
necessarily a solution to this question (function)?" In our case,
the data type `[1, 2, null, false, "hi"]` does not contain the value
`"dailyprogrammer"`. If our function was passed this array, it would return
the `None` type. On the other hand, if it was passed
`[1, 2, null, false, "dailyprogrammer"]`, we could return a
`Some(TreasurePathCrumb.Index(4))`!

With all these pieces in place, we now know which types our recursive solution
requires. We just need to write the recursive function which can do a match
on the terminal types and can recur on the collection types. For clarity,
I split the function on the collection types out into their own functions.
(I also implemented my own Option type, because I forgot F# has it built in.)

```fsharp
type TreasurePathCrumb =
    | Index of int
    | Key of string

type HuntResult =
    | Null 
    | TreasurePath of TreasurePathCrumb list

let rec findMapTreasure (json:(string * JsonValue) list) =
    match json with
    | [] -> HuntResult.Null
    | (key, value) :: rest ->
        match findTreasure value with
            | HuntResult.Null -> findMapTreasure rest
            | HuntResult.TreasurePath (path) -> HuntResult.TreasurePath (TreasurePathCrumb.Key(key)::path)

and findListTreasure (list:JsonValue list) (index:int) =
    match list with
    | [] -> HuntResult.Null
    | first :: rest -> 
        match findTreasure first with
            | HuntResult.Null -> findListTreasure rest (1 + index)
            | HuntResult.TreasurePath (path) -> HuntResult.TreasurePath (TreasurePathCrumb.Index(index)::path)

and findTreasure (json:JsonValue) =
    match json with
        | JsonValue.Null -> HuntResult.Null
        | JsonValue.Boolean b -> HuntResult.Null
        | JsonValue.Float f -> HuntResult.Null
        | JsonValue.Number n -> HuntResult.Null
        | JsonValue.String s ->
            if s = "dailyprogrammer" then HuntResult.TreasurePath([])
            else HuntResult.Null
        | JsonValue.Array a -> findListTreasure (Array.toList a) 0
        | JsonValue.Record map -> findMapTreasure (Array.toList map)
```

The `findTreasure` function is trivial to understand: if given a terminal
type, return the option, and if given a compound type, refer to the
appropriate function implementation for more information.

`findMapTreasure` and `findListTreasure` work with the same three modes:
1. If the collection is empty, the value isn't here, and return None.
2. If the value of the next item in the collection isn't the treasure,
   recur with the rest of the collection
3. If the value of the next item is the treasure, return it! (With a
   crumb, of course.)

## Clojure Solution

As mentioned above, I needed to meditate on the types of this solution like I
would with F# before I could even begin to think about implementing it in
Clojure. This was true even though I wrote the Clojure solution first!
Although Clojure doesn't require being as contractually formal with types as
F# does, it doesn't obviate the need for clearly establishing the types
relationships. (Maybe this is part of what Rich Hickey refers to as
[Hammock-driven development](https://www.youtube.com/watch?v=f84n5oFoZBc)?)

Ultimately, however, I found myself confronting the following problems with the
Clojure implementation:

1. How do I accurately capture what type(s) the return type can be?
2. If I can't pattern match on union types, what other ways can I pattern match on each of the 6 types?
3. [Since Clojure doesn't have (effective) mutual recursion](http://jakemccrary.com/blog/2010/12/06/trampolining-through-mutual-recursion/),
   how can I have all recur calls jump back to the same function?

For anyone who has programmed in a dynamically typed language before, the
solution to question 1 is trivial: don't express the types,
express the values, and just make sure you can handle the types correctly
wherever you catch them.

Okay, so we just return e.g. a list of either integers or strings. That's not
too bad at all. But how should we solve questions 2 and 3?

As it turns out, Clojure has a solution for both of those, and I didn't believe
it would work until I tried it myself!

Although Clojure doesn't implement classes, it does implement
something akin to methods, using
a clever technique dubbed [protocols](http://www.braveclojure.com/multimethods-records-protocols/#Protocols).
Protocols essentially permit dynamically defining methods on object types,
even if you don't have the source for those object types, and even if they
aren't aware of your code.
([In other words, they solve the expression problem.](http://adambard.com/blog/structured-clojure-protocols-and-multimethods/))

Protocols consist of two parts:
1. Define the protocol, analogous to defining an interface.
2. Implement the protocol for a specific type. This is like implementing an
   interface, with the important distinction that it allows the implementation
   retroactively.

```clojure
(defprotocol ContainsTreasure
  (find-treasure [obj]))

(extend-protocol ContainsTreasure
  nil
  (find-treasure [obj]
    false)
  java.lang.Integer
  (find-treasure [obj]
    false)
  java.lang.Boolean
  (find-treasure [obj]
    false)
  java.lang.Double
  (find-treasure [obj]
    false)
  java.lang.String [obj]
    (= "dailyprogrammer" obj)))
```

Protocols solve our earlier problem 2 using traditional polymorphism. We can
simply implement the method for each of the 6 types
(although only the terminal types are shown here), and we will have the
appropriate type-based dispatching. Pretty cool!

I was surprised to discover that, in this case, protocols also permit
self-recursion! Because the interface of the protocol was uniform across
all 6 types, each protocol implementation was able to dive back into
the same function defined on another type:

```clojure
(extend-protocol ContainsTreasure
  ; iterate over vector, tracking index, and see if any values
  ; recursively satisfy the value check. If so, return the accumulated
  ; path back.
  clojure.lang.IPersistentVector
  (find-treasure [obj]
    (loop [i 0
           elems (seq obj)]
      (let [f (first elems)
            treasure (find-treasure f)]
        (cond
          treasure (if (seq? treasure)
                     (cons i treasure)
                     (list i))
          (nil? (next elems)) false
          :else (recur (inc i) (rest elems))))))

  ; iterate over map, tracking keys, and see if any values
  ; recursively satisfy the value check.
  clojure.lang.IPersistentMap
  (find-treasure [obj]
    (loop [kvpairs (seq obj)]
      (let [kv (first kvpairs)
            treasure (find-treasure (second kv))]
        (cond
          (nil? kv) false
          treasure (if (seq? treasure)
                     (cons (first kv) treasure)
                     (list (first kv)))
          :else (recur (rest kvpairs)))))))
```

There are many keywords here, which perhaps make this a bit tricker to follow
than the equivalent F# function, but they both do the same action.

1. Store the next item in the sequence in `f`/`kvpairs`. Check whether it's
   the specified value.
2. If it is, then return the crumb to the value.
3. If it is not, keep recurring.

## Comparison of Solutions

In my unscientific ad-hoc benchmarking, the Clojure solution ran on the hardest
data set in about 140ms in the REPL (Ubuntu), while the F# solution ran in
about 200ms in F# Interactive (Windows 7). 
I was actually surprised by how much quicker Clojure seemed, although I'm
probably missing several optimizations in each language.

### Feel of Languages

F# definitely felt more natural to express this problem. I think its powerful
and flexible static type system allows for expressing any desired combination
of input and output types, and having confidence that they work consistently.
(In contrast, I spent a few hours working out kinks in the recursion of the
Clojure code, necessitated by not having a compiler tracing the types of the
parameters through the code execution.) Union types worked to great effect
here, and the recursive nature of the problem really lent itself to the
functional paradigm.

On the other hand, I was thoroughly impressed by how well Clojure used
protocol-based polymorphism to handle this trivial case of seemingly
heterogeneous polymorphism. Although I do suspect that a more complex
data model would require Clojure to start implementing dynamic dispatch
using lookup tables (which seems somewhat gross to me), I would not
rule Clojure out just for that. (After all, what does C do?)

Type dispatching aside, I found that the Clojure code was more of a joy
to write when implementing scaffolding code around the core algorithm.
This seems reasonable, as I don't know many people who like wrestling
with types when reading or writing files (unless they really do need
to catch all sorts of exceptions). I didn't find Clojure to be as strong
at expressing the actual algorithm as I found F#, as mentioned above.
My takeaway from this would probably be that, depending on whether
flexible and rapid system design or strong algorithmic modeling is more
important, Clojure or F# may be a more natural fit.

Do you have any thoughts on which language you prefer? Leave your
thoughts below!

## References

[My F# solution](https://gist.github.com/Artiavis/29de21935d0afae782c4)
[My Clojure solution](https://gist.github.com/Artiavis/017b42017a3275cbbfe8)

