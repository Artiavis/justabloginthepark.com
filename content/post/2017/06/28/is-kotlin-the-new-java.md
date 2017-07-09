+++
date = "2017-06-28T00:20:27-04:00"
description = "Kotlin is one of the new JVM programming languages on the block. What is its niche? Does it supplant Java within its own niche? I have my own opinions on the matter, but only time will tell."
tags = ["programming", "java", "kotlin", "clojure", "scala"]
title = "Is Kotlin the new Java?"
+++

One of the programming languages I've (essentially) been ignoring for the past
couple of years has been [Kotlin](http://kotlinlang.org/),
the &ldquo;better Java&rdquo; from Jetbrains,
the author of IntelliJ and other IDE's.[^first-heard-about-kotlin]
Recently, Kotlin has come back into focus for me for the following reasons:

[^first-heard-about-kotlin]: I first heard about Kotlin around 2013, which happens to be the time that I was doing some light Android programming. At the time, it sounded interesting, but not much enough to invest my energies in its study.

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
opt-in.
[As motivated above]({{< ref "#some-features-need-to-exist-at-the-language-level" >}}),
the road to hell is paved with good intentions; something more is needed;
a clean-break through an entirely novel programming language
targeting the JVM but with both strong backwards compatibility and stronger intelligence
is the simplest solution. There are three primary candidates bandied
about in modern language discussions:

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

If you're interested in skipping to the Kotlin assessment,
[click here]({{< ref "#kotlin-the-new-java" >}}).
If you're interested in skipping to the conclusion with its total scores for
each programming language based on the criteria above,
[click here]({{< ref "#scoring-java-replacements" >}}).

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

Feature               | Score | Explanation
----------------------|-------|---------------
POJOs                 | 0     | Clojure prefers loosely maps to typed objects[^universal-schema], but does not really go in for POJO's[^records-are-not-pojos]. For Java programmers looking for POJO generation, this is confusing and not up their alley.
Null Safety           | 0     | Clojure takes an approach often called &ldquo;[`nil` punning](https://blog.scalac.io/2015/05/31/dealing-with-npe.html)&rdquo;, which is like an `Option` type[^nil-punning-python]. However, although Clojure's standard library is well-implemented for nil-punning, it does not help with Java-style development.
Immutable Collections | 1     | Clojure's persistent data structures aren't just superb, they have set the standard for persistent data structures in mainstream languages. [Even Google's closure compiler](https://github.com/google/closure-compiler/blob/master/src/com/google/javascript/jscomp/newtypes/PersistentMap.java) uses Clojure's implementation.
Interop               | 0     | Although Clojure *can* generate classes which match those Java provides, they are strictly opt-in (not generated by default). The default means of invoking Clojure from Java requires going through a facade.[^clojure-java-api-example]
Performance           | 0     | Clojure's indirections and abstractions generally hurt performance relative to Java. Between boxing all variables, laziness, persistent data structures, and reflection when calling Java API's, Clojure's performance is much slower than Java's for equivalent, idiomatic code.[^clojure-performance-apology]
Learning Curve        | 0     | Although Clojure's runtime is internally consistent, it presents many novel concepts for a career Java programmer, which draw out the ramp-up-period. Python/Ruby/JavaScript programmers may have an easier time.
No Language lock-in   | 0     | Clojure and Java are essentially distinct, albeit complementary, languages and runtimes. Strong buy-in is essential to pursuing a Clojure investment.[^clojure-java-synergies]
Few Esoteric Features | 1     | Clojure's beauty as a Lisp is that there aren't any hidden features waiting to trip you up. Its libraries are opt-in and can be adopted slowly, rather than all-at-once.
Total                 | 2     | Clojure was never meant to replace the Java language so much as the Java low-level programming paradigms. It cannot be considered a Java language successor.

[^universal-schema]: Clojure maintainers sometimes call this [the universal schema](http://docs.datomic.com/schema.html)
[^records-are-not-pojos]: Clojurians might object that [records](https://clojure.org/reference/datatypes) have *some* POJO-like semantics, but even so, Java programmers will be confused about why their POJO implements the `Map` interface.
[^nil-punning-python]: Nil punning will be instantly recognizable to Python and Ruby developers, as the nil type is used as a form of `Option` monad in those languages. Its value depends on how good core libraries are for manipulating potentially nullable results.
[^clojure-java-api-example]: See https://clojure.github.io/clojure/javadoc/clojure/java/api/package-summary.html. The overall effect makes sense considering how dynamic Clojure is, but is unpleasant to call from Java.
[^clojure-performance-apology]: That isn't to say that Clojure is wasting cycles or poorly optimized! Rather, its runtime model is far more dynamic than that of a Java-like, and thus cannot be used as a sight-unseen replacement with identical performance.
[^clojure-java-synergies]: Going between Clojure and Java requires a large mental shift, and truthfully, synergize through their disparate strengths and weaknesses. Java, with its dogmatic emphasis on Object-oriented Programming, is good for modeling state. Clojure, as a Lisp, is good at modeling business logic. Although they complement each other, going back and forth between them is mentally challenging.

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
   2. In general, many of Scala's functions _also_ use (or abuse) the implicits anti-feature,
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

Feature               | Score | Explanation
----------------------|-------|---------------
POJOs                 | 1     | Scala has this
Null Safety           | 0.5   | Scala has `Option`, which is close
Immutable Collections | 1     | Scala has this
Interop               | 0     | Scala can call Java, but Java struggles to call Scala in more advanced use cases. [Paul reported a bug](https://issues.scala-lang.org/browse/SI-4389) where Java could not call the `map` function from Scala; Scala's author gave up on trying to make it work.
Performance           | 0.5   | Scala *is* compiled, but is riddled with performance pitfalls due to abuse of implicits and the boxing which implicits often perform under-the-hood. It ends up being faster than Clojure, but still slower than Java.
Learning Curve        | 0     | Scala's learning curve is massive and quite infamous. [Twitter warns against using type classes and implicits due to the pitfalls involved.](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Implicits)
No Language lock-in   | 0.5   | Although technically Scala and Java code can call each other, and both are statically typed, this looks like a bit of a one-way door. Java can't infer enough about Scala's type system to make calling the most powerful Scala code easy. And Java can't embed types in a meaningful way to Scala's compiler.
Few Esoteric Features | 0     | As mentioned above, Scala's use of implicits trips up even veteran Scala programmers regularly. Immutables alone are enough to cost this point to Scala.
Total                 | 3.5   | Scala has a lot going on for it, and can be used to great effect by smart, driven programmers, but has enough dark corners and mistakes to make it a poor choice for an average enterprise programming team.

## Kotlin, the new Java?

Kotlin is a neat little language out of [JetBrains](https://www.jetbrains.com/),
the company behind the venerable 
[IntelliJ IDEA](https://www.jetbrains.com/idea/) products.
When JetBrains first announced Kotlin,
[they motivated it thus](https://blog.jetbrains.com/kotlin/2011/08/why-jetbrains-needs-kotlin/):

> [I]t's about our own productivity... Although we’ve developed support for
> several JVM-targeted programming languages, we are still writing all of our
> IntelliJ-based IDEs almost entirely in Java... 
> We want to become more productive by switching to a more expressive language.
> At the same time, we cannot accept compromises in terms of either Java interoperability...
> or compilation speed.

In practice, Kotlin is a pragmatic language which builds upon the (now aging)
primitives Java provided several years ago. Like C# before it, Kotlin tries to
polish up and fuse together great features of other mainstream programming
languages. It is neither a compiler research project like Scala nor the
slow-moving behemoth which is the Java language itself. Like Clojure and Scala,
Kotlin manages to achieve the following remarkable language features without
sacrificing JVM6 compatibility:

* Seamless POJO generation
* Streaming API's
* Labmdas
* `null` is a recognized and first-class aspect of the type system
* [Declaration-site variance](https://kotlinlang.org/docs/reference/generics.html#declaration-site-variance) (more powerful generics)
* [Immutable data structures](https://kotlinlang.org/docs/reference/collections.html) (technically read-only and mutable variations)
* [Extension methods](https://kotlinlang.org/docs/reference/extensions.html)
* [Asynchronous routines](https://kotlinlang.org/docs/reference/coroutines.html)

Even when using Java 8, many of these features are simply unimaginable as future
additions to the Java programming language. Java may require a clean break to
implement many of these features, even though technically many of them could be
introduced in a backwards-compatible manner. Yet, many of these features have
been available in C# for years now.

### Kotlin generates Java fluent code

The truly unique thing about Kotlin among the mainstream JVM languages
(sorry [Ceylon](https://ceylon-lang.org/) and [Gosu](https://gosu-lang.github.io/)!)
is that Kotlin 
[*accomplishes all these features in a Java-fluent manner!*](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html)

1. POJO's generated by Kotlin are nearly identical to Java POJO's
2. Kotlin extension methods translate into run-of-the-mill Util classes
3. The type system treats all references incoming from Java as potentially null,
   and once data types are imported into Kotlin, are presumed to never be null
   (unless opted into). For publicly exported API's, Kotlin will add null guards
   to guarantee that Java code cannot misbehave and pass nulls into Kotlin.
4. Kotlin is smart enough to know about generics within its type system, but will
   export these types to Java in a way it can understand.
5. Kotlin internally pretends that integers, doubles, etc are objects of types
   `Int` and `Double`. But when compiling, Kotlin knows that creating boxed numerics
   is a method of last resort. Whenever possible, Kotlin will prefer the primitive
   types `int` and `double` over Java's `Integer` and `Double`.
6. Kotlin's type system differentiates between mutable and immutable data structures,
   but during compilation, all `List` types translate to e.g. `java.util.ArrayList`,
   *whether or not* they were marked as being mutable.

In these ways, Kotlin manages to have its cake and eat it too. Java code calling
Kotlin code need never know that the code was generated by Kotlin; and Kotlin
can impose its more discerning worldview upon the JVM without incurring large
runtime costs.

[Click here to skip to Kotlin scoring.]({{< ref "#scoring-kotlin" >}})

### Some Kotlin/Java Examples

In the interest of saving some lookups, I'll demonstrate some of the code interop
between Java and Kotlin (in both directions) to show how powerful the system is
while sacrificing little.

#### POJO Generation

````kotlin
data class User(var name: String = "", var age: Int = 0)
````

translates to something like:

````java
public final class User {
    private final String name;
    private final int age;

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() { /* .. */  }
    public int getAge() { /* .. */  }
    public void setAge(int age) { /* .. */  }
    public void setName(String name) { /* .. */  }
    public boolean equals(User user) { /* .. */  }
    public int getHashCode() { /* .. */  }
    public String toString() { /* .. */ }
    public User copy() { /* .. */ }
}
````

#### POJO Properties

Those who have coded in C# are familiar with properties, which are essentially
autogenerated getters and setters for a don't-care field. Kotlin simplifies the
access and consumption of `getField()` and `setField(...)` methods in Java by
transparently translating them to direct-field access when possible.
[As shown on the interop page](https://kotlinlang.org/docs/reference/java-interop.html#getters-and-setters):

````kotlin
import java.util.Calendar

fun calendarDemo() {
    val calendar = Calendar.getInstance()
    if (calendar.firstDayOfWeek == Calendar.SUNDAY) {  // call getFirstDayOfWeek()
        calendar.firstDayOfWeek = Calendar.MONDAY       // call setFirstDayOfWeek()
    }
}
````

Kotlin seamlessly generates the legacy setters and getters, 
*even for accessing legacy Java types*. Under the hood, everything looks like
Java.

#### Package-level Functions

Kotlin has a friendlier approach to allowing its types to be consumed by Java.
Constructs such as top-level (package-level) functions 
[map into namespaced static methods](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html#package-level-functions):

````kotlin
// stringutils.kt
package stringutils

class Helper

fun trim2(String s) = s.trim()
````

translates to

````java
package stringutils;

public class Stringutils {
    public class Helper { }

    public static String trim2(String s) { return s.trim(); }
}
````

For those familiar with Python, this approach is fairly self-explanatory. All
objects and methods can be wrapped internally within a wrapper class with no
loss of performance or generality. *Only from Java* is this an inconvenience
to implement, because of Java's pomp and ceremony. In practice, consuming such
code is trivial even from Java, and it's even easier from Kotlin.

#### Extension Methods

A more natural implementation of the above would be to *add a method* to the
`String` class so that this `trim2` helper can be used everywhere. This is
allowed in C#, Python, etc, but not strictly allowed in Java (even in Java 8!).
Kotlin does some sugaring to allow this (I believe this is the same as how C#
accomplishes it):

````kotlin
// stringutils.kt
fun String.trim2 = this.trim()
````

would compile down to a helper function being called as:

````java
package stringutils;

class Stringutils {
    public static String trim2(String s) { return s.trim(); }
}
````

#### Inline-Functions

Kotlin implements (in a Java 6 compatible way!) an API much like Java 8's streams.
The way it does this is very clever:

* Kotlin allows certain functions to be declared as inline (for lambda purposes)
* Inline functions get inlined by the compiler at the call site (specifically 
  calls to inline-able functions get literally inserted at the call-site, within
  reason). There's no method calls or object instantiations whatsoever.
* Therefore, the Kotlin (JVM6) equivalent of streams would be several stream-like
  function calls which get inlined into something analogous to a slower for loop
  (much like Java 8 streams).

This generality isn't *100% true* &ndash; technically Java 8 has specialized
bytecode instructions for primitive types, which Kotlin can only use if you opt
into a JVM8 version of the Kotlin runtime. However, it still gets one remarkably
close to the desired goal.
([You can read a bit more about this on this Reddit thread.](https://www.reddit.com/r/Kotlin/comments/59dh54/inlining_generated_code_explanation/d980lag/?st=j4xa4gdi&sh=302ee146))

Combined with Kotlin's strong support for syntactic sugaring of lambda functions,
and you can wind up with a limited type-safe form of macro. Consider this
example [from Daniele Bottillo on Medium for advanced Android tooling](https://medium.com/@dbottillo/kotlin-by-examples-methods-and-lambdas-25aef7544365):

````kotlin
inline fun debug(code: () -> Unit){
  if (BuildConfig.BUILD_TYPE == "debug"){
    code() 
  }
}

fun onCreate(savedInstanceState: Bundle?) {
  debug{
    showDebugTools();
  }
}
````

Although this looks exactly like the kind of indirection that would normally
waste CPU cycles (and count against Android's limit on callable methods per app),
Kotlin's compiler compiles this down into a single method call with no dispatch
costs at all.

````kotlin
fun onCreate(savedInstanceState: Bundle?) {
    if (BuildConfig.BUILD_TYPE == "debug") {
        showDebugTools();
    }
}
````

### Other Kotlin-from-Java Quirks

It's clear that Kotlin tries very hard to generate fluent Java bytecode when
possible, especially with zero-overhead. However, much like with Scala and Clojure,
Kotlin's default methods will not look 100% like handwritten Java (although they
get *much* closer):

* Kotlin packages really look more like namespaces. 
  * All Kotlin packages translate
    to Java packages *with accompanying wrapper/namespace classes*. 
  * The autogenerated Java class file generally is called `MypackageKt.class`
    instead of `Mypackage.class`, as might be expected naively. This is not a
    deal-breaker by any means, but it's *slightly* jarring to naive users.
* [Companion objects and other object-level indirections](https://stackoverflow.com/questions/38120494/how-to-access-kotlin-companion-object-in-java)
  result in helper fields getting compiled into the relevant classes. In Kotlin
  these are almost invisible due to syntactic sugaring, 
  but from Java, they must be explicitly referenced.
* Due to type erasure,
  [some theoretically generics correct code](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html#handling-signature-clashes-with-jvmname)
  requires name-mapping so that it can compile for Java. This is better than
  requiring reflection at runtime, but is somewhat jarring. `@JvmName` works here.
* [Overloaded functions in Kotlin](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html#overloads-generation)
  are only compiled down to overloaded Java methods with the annotation
  `@JvmOverloads`.

Although this isn't ideal, to my eye at least, Kotlin appropriately straddles
the divide between adding language features with a suitable backwards-accessibility
mode, while still making inroads with language design (and while having good
performance)!



### Scoring Kotlin

Given that Kotlin was specifically designed with the intention of being
forward and backward compatible with Java, it is no surprise that it checks
most of my boxes:


Feature               | Score | Explanation
----------------------|-------|---------------
POJOs                 | 1     | Kotlin has this
Null Safety           | 1     | Kotlin has this
Immutable Collections | 0.5   | Kotlin has read-only and writable interfaces over `java.util.*` collections, but this is not quite what I want. I'd rather have bona-fide immutable collections. There's a proposal for this but it's not in production.
Interop               | 1     | Kotlin's interop is superb and one need never know that Kotlin generated the code
Performance           | 1     | Kotlin's performance is in line with that of Java
Learning Curve        | 1     | Kotlin has the most modest learning curve of any JVM language after Java
No Language lock-in   | 1     | Lock in is minimal with Kotlin, due to its compatibility
Few Esoteric Features | 1     | Kotlin has a few optional features, but all are present in C#
Total                 | 7.5   | No doubt due to Kotlin's intense focus on being a Java successor, it manages to scratch nearly every itch without having any major pitfalls.

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
No Language lock-in   | 0       | 0.5   | 1      | 1
Few Esoteric Features | 1       | 0     | 1      | 1
Total                 | 2       | 3.5   | 7.5    | 5

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
* [JetBrains' debut blog post about Kotlin](https://blog.jetbrains.com/kotlin/2011/08/why-jetbrains-needs-kotlin/)
* Scala rant by Paul Phillips, Scala contributor, against Scala's idiosyncrasies:
  {{< youtube uiJycy6dFSQ >}}
* [Scala - the good, the bad, and the very ugly.](https://www.slideshare.net/Bozho/scala-the-good-the-bad-and-the-very-ugly). A similar slide deck documenting Scala's implicit warts.
* [Calling Kotlin generics from Java looks fluent](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html#variant-generics)
* [Calling Scala generics from Java requires tortuous casting and reflection](https://stackoverflow.com/questions/30789580/call-scala-generic-method-from-java)
* [Scala, Kotlin, and Clojure null handling](https://blog.scalac.io/2015/05/31/dealing-with-npe.html)
* [Twitter guide on what to use and what to avoid in Scala](http://twitter.github.io/effectivescala/)