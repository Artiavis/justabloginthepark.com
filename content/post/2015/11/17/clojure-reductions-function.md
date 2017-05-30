+++
title = "The Clojure “Reductions” Function"
tags = ["clojure", "programming"]
date = "2015-11-17"
+++


Tonight, while attempting a problem at [4 Clojure](http://www.4clojure.com)
(problem number omitted so as not to give too many hints),
I was struck by the following problem:

> What if I need a Clojure function which can take a sequence of functions
  and can sequentially call them on some seed value?

I'm specifically looking at something like:
```clojure
(defn some-fun
  [seed-val & funs]
  ; Keep passing the calculated value through, while also appending to sequence
  (list ((first funs) seed-val) ((second funs) ((first funs) seed-val)) ...))
```

I ended up hacking something together using 
[`iterate`](https://clojuredocs.org/clojure.core/iterate),
but which wasn't
terribly elegant.

```clojure
(defn some-fun
  [seed-val & funs]
  ; Cycle through the given functions by index and build
  ; the incremental result of calling them into a sequence using map
  (let [funs-len (count funs) funs (vec funs)]
    (map first (iterate (fn [[x i]] [((funs (mod i funs-len)) x) (inc i)]) [v 0]))))
```


When I compared my answer against a sample answer by a Clojure expert, I was
blown away to see that Clojure already has a function which obviates all
of my messy hand-rolled cycling:
[`reductions`](https://clojuredocs.org/clojure.core/reductions).

Although the examples on [Clojure Docs](https://clojuredocs.org) all reference
the naive case of building a sequence of values from
**a single seed function and a (potentially) infinite sequence of values**,
the expert actually realized another application for this problem!
*Instead of seeding a function*, the expert
**seeded a value to a (potentially) infinite sequence of functions**!
Specifically, a call was made to the 
[`cycle`](https://clojuredocs.org/clojure.core/cycle) function
to cause a list of functions to become an infinitely repeated sequence
of functions, which could then be lazily "built up" over the seed value.
For example, to retrieve the first 5 terms of the sequence

<div>$$\langle 2&#94;k:k\in\Bbb N_0\rangle$$</div>

we can use the code

```clojure
; Get the first 5 iterations of the sequence

(take 5 (reductions (fn [v f] (f v)) 1 (repeat (fn [x] (* 2 x)))))
```

Just another example of how crazy and clever functional programming can
really be if you can train yourself to think functionally.

### Edit:

Immediately after publishing this, I realized that the summary example
could be replaced by the more idiomatic `iterate` function for the
trivial case where there is only one function to call. That would
look like

```clojure
(take 5 (iterate (fn [v f] (f v)) 1 (fn [x] (* 2 x))))
```
