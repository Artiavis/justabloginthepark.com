+++
date = "2017-06-26T23:13:27-04:00"
description = "Kotlin is one of the new JVM programming languages on the block. What is its niche? Does it supplant Java within its own niche? I don't have the answers but I have some thoughts on the matter."
tags = ["programming", "java", "kotlin", "clojure", "scala"]
title = "Is Kotlin the new Java?"
draft = true
+++

One of the programming languages I've (essentially) been ignoring for the past
couple of years has been [Kotlin](http://kotlinlang.org/),
the &ldquo;better Java&rdquo; from Jetbrains,
the author of IntelliJ and other IDE's.

I first heard about Kotlin around 2013, which happens to be the time that I was
doing some light Android programming. At the time, it sounded interesting, but
not much enough to invest my energies in its study; (since then, 
[I've been focusing more upon Clojure](/tags/clojure/) than other languages).
Recently, Kotlin has come back into focus for me for the following reasons:

* [Google finally announced official Android support for Kotlin](https://developer.android.com/kotlin/index.html)
* Steve Yegge, that infamously opinionated programming language enthusiast,
  [wrote a patently Yeggian post about how Kotlin scratches his itches](http://steve-yegge.blogspot.com/2017/05/why-kotlin-is-better-than-whatever-dumb.html)
  without supporting academic or impractical features.
* I began to tire (after only a handful of months!!) of diligently reminding my
  colleagues to prefer [Guava Immutable collections](https://github.com/google/guava/wiki/ImmutableCollectionsExplained)
  over Java collections,
  [Lombok](https://projectlombok.org/features/Value)/[Immutables](https://immutables.github.io/) over hand-rolled POJO's, and
  [to please please use the `@Nullable` and `@Nonnull` annotations](https://stackoverflow.com/questions/13484202/how-to-use-nullable-and-nonnull-annotations-more-effectively)
  or at the very least [`java.util.Optional`](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html)
  instead of returning ambiguous types (such as empty/nullable/possibly full collections of possibly null values).

### Some features need to exist at the language level

To paraphrase Jeff Bezos,

> Good intentions don't work... good mechanisms work.

As the theory goes, people don't deliberately make sub-par decisions
(or in the context of programming, developers don't deliberately introduce bugs
by using less refined API's). The solution isn't to encourage people (or developers)
to try harder or to have a more positive mindset; rather, processes (or API's)
should be put into place which make repeating common mistakes impossible.

I'm beginning to realize that Java itself, with its progression and baggage,
cannot be made consistent with this ethos. Java has null types; it has non-reified generics;
it does not sufficiently differentiate between mutable and immutable data structures.
Although annotation processors exist for Lombok, `@Nullable`/`@Nonnull`,
and libraries exist for `Optional` and `Immutable*` types, these are
*strictly opt-in, not mandatory*.
In other words, *they require good intentions* to work.
And Bezos correctly surmised that (at scale), good intentions are insufficient
to guarantee correct action is consistently taken. Thus, we are left with the
understanding that if Java itself is unwilling or incapable of providing these
features in the language, JVM developers should adopt a language which can.

## But which to choose?

If not using core Java, a meta-language is necessary. But Java's preferred
meta-language, annotations, are already clearly insufficient, in that they are
opt-in. Thus, a clean-break through an entirely novel programming language
targeting the JVM becomes necessary. There are three primary candidates bandied
about:

* [Kotlin](http://kotlinlang.org/), a newish language by Jetbrains, maker of IntelliJ. Considered by many
  to be a primary choice for Android development, although it is seeing adoption
  elsewhere.
* [Scala](https://www.scala-lang.org/), that ancient amalgamation of programming paradigms for the JVM. (Some
  liken it a modern C++ in that it's an everything-including-the-kitchen-sink language,
  with all the baggage that implies.) Scala at one point was claimed to be a
  better Java, but many have backed away from those claims as of late.
* [Clojure](https://clojure.org/), the hip and exotic Lisp for the JVM. Clojure
  too at one point was heralded by some as a better alternative to Java, although as a
  dynamically-typed Lisp, it's not really even trying for that category.

In the interest of solving a well-defined problem, these are my desires from a
language attempting to ascend Java's throne as king of the programming languages:

1. Must provide the three features requested above, namely
   1. Simple, easy, and correct POJO generation
   1. Intelligent, modern data structures implementations (not mutable by default etc)
   1. Good null-checking
1. Must be seamlessly inter-operable with Java, not merely vaguely compatible.
   Included in this is the requirement that API's generated by this language
   should be passable as idiomatic Java.
1. Must not compromise the runtime performance of Java, or otherwise have
   unpredictable performance semantics.
1. The language learning curve must be modest, so that ramping up new developers
   does not take inordinately long, and so that there is not severe lock-in from
   having written API's in this other language. (Relates to inter-operability).
1. Transitioning between languages should
   [preferably be a two-way door](https://medium.com/@dannywen/on-decision-making-3e045c09b173),
   which also relates to the idea of API/platform lock-in.
1. As a soft desire, this language should not have too many esoteric features.
   Obviously features are useful, and some are extremely useful; therefore this
   requirement is more of a marginal judgement value. Where do high-value
   language features stop and trivia-based language features arrive?

If you're interested in skipping to the results,
[click here]({{< ref "#scoring-java-replacements" >}})

## Clojure is a Lisp, not a Java replacement

Although I love Clojure, it's a non-type-checked Lisp which requires an entirely
different development model than what the garden-variety Java/.NET developer
has grown up with. Calling Clojure from Java is odious unless jumping through
hoops, calling Java from Clojure looks odd, and even the syntax and runtime
take a long time to learn (it took me about 4 months of koans and tinkering
after-hours to feel okay with it). Clojure was written to solve problems like:

* Providing a good meta-language for language extension (e.g. macros)
* Sane and even robust concurrency support
* Providing more &ldquo;simple&rdquo; type API's, for some definition of &ldquo;simple&rdquo;

Clojure is great, but these requirements are slightly orthogonal to the requirements
of a Java successor. Macro capabilities are not a hard requirement for a Java
replacement, nor is sane concurrency support (although these are both great things!).
Its indirections are fundamental to any Lisp, but present performance challenges
relative to Java, which require optimization to reduce. In rare circumstances it
can be easier to write Clojure code which correctly runs faster than the equivalent
Java logic (probably in streaming/concurrency situations where indirection is not
used on the Java side), but this is the exception rather than the rule.

Here is how I score Clojure as a Java replacement:

1. Clojure only gets fractional marks on the primary issues of concern:
   1. Clojure itself frowns upon POJO's, preferring maps for everything.
      Clojure maintainers sometimes call this [the universal schema](http://docs.datomic.com/schema.html),
      because keys can be freely added without requiring type changes. There is
      some merit to this argument, but it is distinctly foreign to cultural Java
      code. Clojure *does* provide `record`s, and *does* have machinery to create
      classes, but neither are really POJO generation. 0 points.
   1. Intelligent data structures are one of Clojure's greatest strengths.
      Clojure has immutable data structures by default, and many concurrency
      operators which operate upon them. Clojure gets full marks here.
   1. Clojure takes an approach often called 
      &ldquo;[`nil` punning](https://blog.scalac.io/2015/05/31/dealing-with-npe.html)&rdquo;
      (don't ask me where the name came from).
      This approach, common in Python etc., treats `nil` like an `Optional` in
      Scala, and will basically short-circuit function evaluation if a `nil` is
      passed in. In this way, at the end of a data transform, if anything was `nil`,
      you can just inspect its value at the end of the pipeline. Although this
      works passably in dynamic languages, it's not a real solution to null values, and
      (in my opinion) is an even weaker option than having a real `Optional` type.
      Again, 0 points.
1. Although Clojure *can* generate classes which match those Java provides, they
   are strictly opt-in (not generated by default). The other prominent way of
   calling Clojure from Java is through the [Clojure API for Java](https://clojure.github.io/clojure/javadoc/clojure/java/api/package-summary.html).
   This essentially consists of calling functions like so:

    ````java
     Object object = Clojure.var("my-namespace", "my-object")
     Object result = Clojure.var("clojure.core", "+").invoke(1, 2)
    ````
   It's certainly workable, but it's not native enough. 0 points.

1. Clojure's runtime adds several layers of indirection, which can hurt performance
   relative to Java. Between boxing all variables, laziness, reflection when calling
   Java API's, and immutable data structures by default, Clojure's performance is
   much slower than Java's for equivalent, idiomatic code. That isn't to say that
   Clojure is wasting cycles or poorly optimized! Rather, its runtime model is far
   more dynamic than that of a Java-like, and thus cannot be used as a sight-unseen
   replacement with identical performance. 0 points.
1. Clojure's language runtime is incredibly self-consistent, but also has many novel
   concepts which can take many weeks to acclimate towards, _especially_ for Java
   developers. What Clojure has in terms of simplicity it suffers from in terms of
   novelty to the un-initiated. 0 points.
1. Going between Clojure and Java requires a large mental shift, and truthfully,
   Java and Clojure excel at far different things. Java, with its dogmatic emphasis
   on Object-oriented Programming, is good for modeling state. Clojure, as a Lisp,
   is good at modeling... nearly everything else. Although they're strong
   complements for each other, they're essentially distinct languages. 0 points.
1. I'd say that, for the most part, Clojure doesn't have too many esoteric features.
   Some of the libraries for Clojure are more or less intellectually challenging,
   but as a Lisp, the core language is tiny; everything else is a libray which can
   be looked up fairly easily. And because Clojure doesn't have custom readers,
   most &ldquo;shortcuts&rdquo; can be looked up in the docs. 1 point.

This is not meant as an objective condemnation of Clojure! Clojure is simply far
and away completely inconceivable as an intentional Java replacement. It cannot
be, in any way, considered a Java successor.

## Scala is a good ML experiment, but a poor Java replacement

I've been a bit leery on Scala since a friend showed me
  [a video of a prominent Scala contributor raging against Scala's idiosyncrasies and mistakes](https://www.youtube.com/watch?v=uiJycy6dFSQ).
Although thematically I enjoy ML-style languages (the set of which it is technically a member)
and syntactic sugaring, I lean towards thinking that Scala
as a language is far too highbrow and/or unstable to excel at typical industrial/enterprise use cases.

I would lay most of these issues down at the feet of the two primary weaknesses
of Scala identified in the above talk:

1. Scala has a pervasive hierarchical type system, which allows essentially any data
   type to be cast to any other data type, given the stars align.
1. Scala also has an anti-feature calls &ldquo;implicits&rdquo;, which is the
   compiler's ability to capriciously apply hidden glue methods to perform
   castings on/between data of the types defined above. As Paul explains in his
   video, this enables two types of bizarre and definitely incorrect type
   completion behaviors to occur:

   1. Collections can have bizarre or inexplicable casts performed
      automatically, instead of failing to compile. (This is a huge sin in an ML language!)

        ````scala
        scala> // Accidentally promotes to Object
        scala> List(1, 2) ::: List(3, 4.0)
        res0: List[AnyVal]  = List(1, 2, 3.0, 4.0)
        scala> // Accidentally promotes to Object, and then consumes the data
        scala> List(1, 2, 3).toSet()
        res1: Boolean = false
        scala> // Promotes to Object and then the String gets compared with Ints
        scala> List(1, 2, 3) contains "some string"
        res2: Boolean = false
        ````
   2. In general, many of Scala's functions _also_ use/abuse the implicits anti-feature,
      causing sheer terror in functions when even the slightest
      changes to the syntax occur:

        ````scala
        // The conceptual ideal of the map function in Scala:
        def map[B](f: (A) => B): Map[B]
        // The properly labeled implementation of map in Scala:
        def map[B, That](f: ((K, V)) => B)
        (implicit bf: CanBuildFrom[Map[K, V], B, That]): That
        // Under ideal circumstances, this does "magic"
        scala> BitSet(1, 2, 3) map (_.toString.toInt)
        res0: BitSet = BitSet(1, 2, 3)
        // Under even slight changes to syntax, the magic goes horribly wrong
        scala> BitSet(1, 2, 3) map (_.toString) map (_.toInt) // wat
        res1: SortedSet[Int]= TreeSet(1, 2, 3)
        // And the magic is fairly fragile, at that
        scala> (BitSet(1, 2, 3) map identity)(1)
        // gives a type mismatch because there's no
        // CanBuildFrom[BitSet, Int, ?] for this syntax
        ````

Part of this behavior is understandable. Scala wants to replicate the ease of
use of languages like Python, where dynamic typing allows objects of virtually
any type to be operated and compared against operators of nearly any other type,
at least theoretically. But in practice, this is wrong! Python will complain
when you try to do this, and exceptions will be thrown!
For Scala to sacrifice consistency and correctness, and to so blatantly violate
[the principle of least surprise](https://en.wikipedia.org/wiki/Principle_of_least_astonishment)
means it's not a programming language that's safe for use by typical enterprise
developers, who are accustomed to Java.
*You should not need to be well-versed in compiler semantics* of your preferred
language to spot these mistakes or to prevent them from happening.

But I digress &mdash; let's score Scala as measured.

1. Scala is pretty solid on my desired features of a Java successor:
   1. Scala can generate POJO's just fine.
   1. Scala has both mutable and immutable collections, which is important,
      although Paul does rant above that the collections API's are half-baked
      due to over-reliance on the global type hierarchy. Nevertheless, I have to
      give this one to Scala.
   1. [As linked above](https://blog.scalac.io/2015/05/31/dealing-with-npe.html),
      Scala prefers to handle optional values using its `Option` type. I love the
      `Maybe`/`Option` monad and I think that this is great, but it's a little
      bit lackluster in that it doesn't solve Java's `null` dilemmas.
      I'll give this a half point since Scala can model optional types, but it
      loses points because it has no way of actually protecting itself from null pointers.
1. When it comes to calling Scala from Java, things are still a bit manual.
   Calling some classes is rather hideous and convoluted. From Paul's talk above,
   [he reported a bug](https://issues.scala-lang.org/browse/SI-4389) with Scala
   because he couldn't invoke some &lsquo;simple&rsquo; Scala method from Java.
   The author of Scala reported that even he could not get the code to compile
   under Java, and gave up. [Some brave/bored souls](https://stackoverflow.com/questions/11678756/calling-scala-monads-from-java-map)
   on Stack Overflow found some solutions, most of which involve hideous references
   to nested types, or required hand-rolling anonymous types which Scala's compiler
   autogenerates. So I'm going to fail Scala here, in that its core routines
   can often result in unwieldy and inexplicable types being inserted all over
   the place. I'm going to give this 0 points for simplicity.
1. Most of Scala's indirections have already been documented above.
   They arise from how Scala doesn't have good ways of statically resolving
   types universally, and so inserts glue code and upcasts in many places to
   achieve its &ldquo;power&rdquo;. From what I understand, Scadla still runs a
   bit faster than Clojure, but between all the conversions and casts it has
   going on, it can still wind up being a good amount slower than the equivalent
   Java code. 1/2 a point.
1. Scala, as you may have already guessed, has a _huge_ learning curve. You need
   to learn all the things _not_ to do in the language, like avoiding
   [type classes and using implicits yourself](http://twitter.github.io/effectivescala/#Types and Generics-Implicits),
   and how not to shoot yourself in the foot with the basic language runtime. 0 points.
1. Going between Scala and Java does not appear to be for the faint of heart.
   Scala's type system is so deep (or deeply broken, depending on your viewpoint)
   that going into or out of the Java layer involves sacrificing a fortune of
   type hinting to the compiler. And calling Scala from Java looks like something
   from a nightmare in all but the simplest or most wrapped scenarios. 0 points.
1. Hahahaha of course Scala has esoteric features, 0 points.

## Kotlin, the new Java?


## Scoring Java replacements

Without further ado, these are the final scores (I threw in Java
as a control without rationalizing its score too much):

Feature               | Clojure | Scala | Kotlin | Java
----------------------|---------|-------|--------|------
POJOs                 | 0       | 1     | 1      | 0
Null Safety           | 0       | 0.5   | 1      | 0
Immutable Collections | 1       | 1     | 0.5    | 0
Interop               | 0       | 0     | 1      | 1
Performance           | 0       | 0.5   | 1      | 1
Learning Curve        | 0       | 0     | 1      | 1
Language lock-in      | 0       | 1     | 0      | 1
Few Esoteric Features | 1       | 0     | 1      | 1
Total                 | 2       | 4     | 6.5    | 5

There's a couple of reminders here:

* This was scoring languages on how well they are positioned to replace _Java_,
  not how good they are as standalone JVM languages
* This analysis is oriented towards teams and companies which have a large interest
  in both Java code and Java developers, not towards polyglot teams of programmers
  who do hobby projects in Haskell on the side.

The Java 8 control was added as a reminder that, when it comes to the features
enterprises value in Java, such as stability, learning curve, lock in,
and predictably good performance, Java (6, 7, 8, etc) is not that bad. It's only
when one starts discussing quality-of-life concerns that Java starts looking less
desirable to large organizations.
_In this very narrow sense of language appeal to a large organization_, it appears
that Kotlin is _even better_ than Java due to its strong compatibility
and similar performance, while Scala is _slightly worse_ because its learning
curve and lock-in are a net loss to large companies.

## Takeaways

I feel a bit hollow after partially vindicating Java after such a lengthy analysis. 
After all, I set out to replace Java, and it turns out that it's not quite dead yet.
(Some enterprise architects out there are probably laughing at me right now.)
But in another sense, I'm satisfied as well, to see that Kotlin holds its own
and can even be considered a better Java, in many senses. Its no wonder that it's
seen such adoption in Android code bases and the broader industry in such a short
length of time.


## References

* [Official Kotlin documentation](http://kotlinlang.org/)
* [Kotlin &ldquo;Koans&rdquo;](https://try.kotlinlang.org)
* [Steve Yegge on Kotlin](http://steve-yegge.blogspot.com/2017/05/why-kotlin-is-better-than-whatever-dumb.html)
* Scala rant by Paul Phillips, Scala contributor, against Scala's idiosyncrasies:
  {{< youtube uiJycy6dFSQ >}}
* [Calling Kotlin generics from Java looks fluent](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html#variant-generics)
* [Calling Scala generics from Java requires tortuous casting and reflection](https://stackoverflow.com/questions/30789580/call-scala-generic-method-from-java)
* [Scala, Kotlin, and Clojure null handling](https://blog.scalac.io/2015/05/31/dealing-with-npe.html)
* [Twitter guide on what to use and what to avoid in Scala](http://twitter.github.io/effectivescala/)