+++
title = "Recommended Programming Languages for High School Students"
date = "2020-02-22:00:00-05:00"
description = ""
tags = ["programming", "education", "python", "javascript", "java"]
+++

_**Disclaimer**: All opinions expressed herein are my own and don't necessarily
reflect that of my employer._
_**Caveat**: I hold these opinions and make these recommendations specifically 
with respect to high school students (or casual hobbyists)._

I have a friend in my neighborhood who teaches high school computer science.
When she happened to mention that she was trying a new curriculum for one of 
her classes, I asked her which programming language she was planning to use
in her class. She said that she hadn't quite decided yet, but was leaning
towards JavaScript, because it's ubiquitous and (importantly!) runs well on her
school's Chromebook machines. 
Upon hearing that she was favoring JavaScript,
I ran my mouth and
recommend that she instead consider Python.
Based on my professional experience with both JavaScript and Python,
I feel comfortable stating that JavaScript has quite a few pitfalls in terms of
learning, and has a non-trivial path to writing high-quality code.
I also feel comfortable stating that Python has a number of educational virtues,
and has a fairly strong path for students to learn to write high-quality code.



## What makes JavaScript a difficult first language?

I've worked with JavaScript professionally for the past year-and-a-half (backend, read on).
JavaScript _can_ be a productive programming language when a code base is set up with best practices
and _developers know what to avoid_.
My team uses [TypeScript](https://www.typescriptlang.org/), an optional superset of JavaScript which
adds type checking and warnings about many common JavaScript errors.
Without TypeScript, we would definitely make more mistakes, have more bugs, and
have a harder time ramping up inexperienced developers.

I believe JavaScript's anemic types and perilous operators are liable
to be a poor and possibly even painful introduction to computer science.
[There's a famous (_infamous?_) meme](https://www.reddit.com/r/ProgrammerHumor/comments/621qrt/javascript_the_good_parts/) 
about the paucity of good parts in historical JavaScript.
Newer versions of JavaScript since [ES6 (a.k.a. ECMAScript 2015)](https://en.wikipedia.org/wiki/ECMAScript#6th_Edition_-_ECMAScript_2015) have 
mercifully provided sane implementations of many common JavaScript idioms
(classes, arrow functions, `const`/`let`, templates, and more goodies)... provided that
instructors know to avoid pre-ES6 idioms and can somehow steer students clear of
them too.

One of the more infamous examples is the confusion of auto-promoting in comparison
operators, such as
[Which equals operator... should be used in JavaScript comparisons?](https://stackoverflow.com/questions/359494/which-equals-operator-vs-should-be-used-in-javascript-comparisons)

> ```javascript
> '' == '0'           // false
> 0 == ''             // true
> 0 == '0'            // true
> 
> false == 'false'    // false
> false == '0'        // true
> 
> false == undefined  // false
> false == null       // false
> null == undefined   // true
> 
> ' \t\r\n ' == 0     // true
> ```

The fact that JavaScript has _two_ comparison flavors, `==`/`!=` and
`===`/`!==`, is guaranteed to be a source of confusion and error for students.
Few other programming languages have this "dynamic" meaning of equality.

JavaScript is also the only language, to my knowledge, with both an `undefined` _and_ a `null`
entity. JavaScript tends to use `undefined` in ways that other languages use `null`,
but JavaScript also sometimes uses `null` for the same purpose.
There's not much consistency to when JavaScript uses `null` and when it uses `undefined`, either.
So, the upshot is that `undefined` confuses JavaScript students,
while having no redeeming qualities (because `null` can be used for 100% of what `undefined` is used for).
Tony Hoare, founder of Algol, famously called inventing `null` his "billion-dollar mistake".
I'd argue a language with both `undefined` and `null` took a one-billion dollar-mistake and made
it a two-billion-dollar mistake.

I believe that a good general-purpose programming language should include native
data structures for resizeable arrays (sometimes known as vectors or lists)
and for hashtables (sometimes known as maps or dictionaries).
The good news is that JavaScript includes both resizeable arrays and hashtables;
in JavaScript, they're called `Array` and `Object`, respectively.
The bad news is, in the case of `Array`, the behavior is an awkward hybrid of
an actual array type, and `Object`, so it's easy to make mistakes and hard to
spot them.

```javascript
var arr = [];
arr[1] = 1; // Automatically extends the array to be as long as needed.
arr; // [ undefined, 1 ]
arr.length; // 2
arr.key = 'value'; 
arr; // [ undefined, 1 ]
for (var value of arr) {
    console.info(value); // Prints undefined, undefined, 1
}
for (var key of arr) {
    console.info(key); // Prints undefined, 1, key
}
```

Arrays with object-like properties is not a feature, and it's arguably a mistake to have been
put there in the first place. It creates room for all sorts of bugs that
students are unlikely to be able to spot on their own.

There are a few other warts that I'm going to skip over, such as global `this`
(which are ameliorated with array functions)
and some gotchas around prototypical inheritance (which are ameliorated with the new `class` syntax).

## What makes Python a great first language?

Python was one of my first programming languages, and it was actually my first "love" language.
I've moved on for a number of years, but it still holds a fond place in my heart.
I think that Python has a perfect learning curve for students, 
is even more valuable because it includes "batteries",
and students should appreciate that it has a friendly path towards more advanced uses
(such as scripting, automation, web development, data science).

First, let's start with code style.
Style is both learned by experience (reading and writing), but also innate and
unique to an individual. Everyone agrees, however, that a neophyte developer
has to learn their own style _from scratch_, because they have no experience in writing or
reading code.
That's where Python comes in.
Because Python strongly resembles pseudocode, neophytes can learn to read and
write Python while having a lower cognitive burden.
And because Python treats whitespace as significant, new developers are subtly
encouraged to make their own code more legible.

```python
>>> mylist = [ 1, 2, 3, 4, 5 ]
>>> for v in mylist:
      if v % 2 == 0:
        print(v)  # Prints 0, 2, 4
```

In my experience as a programming tutor and mentor, tooling can work hand-in-hand
with the teacher to guide students to better habits and better understanding.
In the example below, Python gives detailed error messages indicating the form
and method behind errors, giving feedback to students about where they may have
gone wrong:

```python
>>> mylist[1] = 1
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
IndexError: list assignment index out of range
>>> mylist['foo'] = 1
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: list indices must be integers or slices, not str
```

Second, Python is (primarily) a back-end programming language; its "native"
environment is analogous (if higher level) than that of C and Java.
Not only does it have native integer and floating-point types,
it can work with files, bytes, unicode, and sockets.
Continuity of learning is important, and I believe it's helpful that a language
a student uses in one course (to learn the basics) can be used in a more
advanced class (to study, for example, networking, or files, or byte serialization).
This is less a knock on JavaScript in particular than promoting a "fully-fledged"
programming environment _like_ Python.
(I first taught myself Python in university to be able to write my own scripts which
run as well on Windows as they do on Linux. I realized I could also use it in my
high-level university classes, and even 
[used it in the final project of my Network Programming class](https://github.com/cuiffo/TeaSteam/blob/3536059debceb5284d5c72cf2747fc88af2ffc33/bin/steamy_server.py)
to implement a video game "matchmaking server".)

Third, Python is a "batteries included" runtime, which is to say, it ships with
a wide variety of helpful (and often production-grade) libraries out of the box.
I have personally used its included libraries to
[SQLite](https://docs.python.org/3/library/sqlite3.htm),
[JSON](https://docs.python.org/3/library/json.html),
[CSV](https://docs.python.org/3/library/csv.html),
[sending emails](https://docs.python.org/3/library/smtplib.html),
[create command-line applications](https://docs.python.org/3/library/argparse.html),
and [logging](https://docs.python.org/3/library/logging.html) before I ever learned
how to obtain third-party code for Python.
This is easy to take for granted, but in practice, none of the other common
"first" languages (JavaScript, Java, C, C++) include first-class support for 
CSV, email, advanced command-lines, or leveled logging.
(JavaScript has JSON, Java and C/C++ do not.)
This is another boon to students, who can dip their toes into more advanced
functionality without having to grok dependency management and installation.

For students of math, science, or engineering, Python has the additional boon
of gaining a robust and fairly comprehensive open-source ecosystem of
math/science/engineering libraries.
You used to need to turn to something like
[Matlab](https://www.mathworks.com/products/matlab.html)
or [Mathematica](https://www.wolfram.com/mathematica/)
to have industry-class math/statistics/engineering libraries.
Those software suites are very nice, especially their collection of engineering
routines; but those platforms are expensive, and their programming languages
are nothing to write home about.
These days, Python can do large subsets of what Matlab and Mathematica can do,
through projects like
[numpy](https://numpy.org/)
and [scipy](https://www.scipy.org/)
and [matplotlib](https://matplotlib.org/)
and [sympy](https://www.sympy.org/en/index.html).
Students can take the knowledge they already have
about their programming environment, apply it to these specialized libraries
to be able to do advanced modeling, without paying a dime.
(I first learned Matlab, which is not a general-purpose programming language,
and later had to teach myself Python so that I could do useful things.)

## What about Java?

I have a love-hate relationship with Java and the Java Virtual Machine (JVM).
I think that the JVM is brilliant technology, which manages to squeeze amazing
performance out of some fairly mediocre code. And I love that it can run code
written in 
[Clojure](https://clojure.org/)
or [Scala](https://www.scala-lang.org/)
or [Kotlin](https://kotlinlang.org/) alongside native Java.
But I think that Java has a number of warts and
[those other programming languages can largely do what Java does, better]({{< relref "is-kotlin-the-new-java.md" >}}).

This isn't the fault of Java per se; it's a product of its time. It was competing
with C++, which is an even lower-level language. It goes out of its way to try
and be explicit about when a piece of code is going to be computationally expensive, and
when a piece of code is liable to be very fast.
It also solved a major annoyance with C/C++ code, by namespacing all data, whether
global or local.

But one of the major pain points of Java, in my opinion, is that it foists its
rather poorly defined "object-oriented programming" concept into a beginner's face.
Beginners are told rules-of-thumb such as, "object-oriented programming is good," 
"data hiding is good," "objects and classes are easier to refactor," and so on.
_While these rules of thumb are all true,
they don't usually apply to introductory programs written by beginners_.
For example, I've seen code like this from beginners fairly often:

```java
class Adder {
  private int x;
  private int y;
  private int result;

  public Adder(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public void add() {
    this.result = this.x + this.y;  
  }

  public int getResult() {
    return this.result;
  }
}
```

My assumption about Java students is twofold:

1. They are given sample programs to write, like adding two numbers.
2. They are told objects make programs "better".

If students take their instructors at face value (and why shouldn't they?!),
they may end up writing over-engineered and nonsensical programs like the
one above, instead of the simpler and more correct:

```java
class Adder {
  public static int add(int x, int y) {
    return x + y;
  }
}
```

In my opinion, students studying basic algorithms (like sorting or n-queens or recursion)
don't need object-oriented programming at all. Objects only really become useful
when students get to classes like data structures, operating systems,
application development, and software engineering.
Therefore, _I prefer when students can gradually ramp into object-oriented programming_,
through the normal course of their studies.

## Takeaways

A high school class in programming can serve two different purposes at the same time.
For some students, provides a taste of computer science, even if they take it no further.
And for others, it can be the beginning of an academic or professional career.
A good programming language should cater to both groups; it should facilitate
computer science fundamentals in a friendly and approachable manner,
while being deep enough to be taken further. I believe that Python is 
that programming language; it is the best of both worlds.
