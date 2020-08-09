+++
title = "Why Kotlin Over Lombok?"
date = "2017-12-23T21:47:01-05:00"
description = "Some developers may believe that Lombok for Java is good enough for them, without having tried Kotlin. In this post, I discuss where Kotlin adds functionality for many Java developers, and why one may want to consider Kotlin instead."
tags = ["programming", "java", "kotlin"]
+++

This is a continuation of the ideas from ["Is Kotlin the New Java?"]({{<relref "is-kotlin-the-new-java.md">}}).

## What is Lombok?

For those of you who are not familiar,
[Project Lombok](https://projectlombok.org/features/all) is a build tool for the
Java programming language, which adds nifty capabilities that many Java developers
feel they sorely lack. Some of the more vanilla features include:

* ["Getter" and "Setter" generators](https://projectlombok.org/features/GetterSetter)
* ["ToString"](https://projectlombok.org/features/ToString) and ["EqualsAndHashCode"](https://projectlombok.org/features/EqualsAndHashCode) generators
* ["Data"](https://projectlombok.org/features/Data) and ["Value"](https://projectlombok.org/features/Value) class generators
* [Automatic resource cleanup](https://projectlombok.org/features/Cleanup)
* [Not-Null](https://projectlombok.org/features/NonNull) assertions
* [Builder class generators](https://projectlombok.org/features/Builder)
* [Constructor helpers of various sorts](https://projectlombok.org/features/constructor)

There's also a few more exotic features (which I personally have not seen developers)
use in the wild, but which no doubt _someone_ is using, including
[suppressing checked exceptions](https://projectlombok.org/features/SneakyThrows), [lazy fields](https://projectlombok.org/features/GetterLazy), [magic "val" keyword](https://projectlombok.org/features/val), [delegation](https://projectlombok.org/features/experimental/Delegate), ["with"ers](https://projectlombok.org/features/experimental/Wither), [util](https://projectlombok.org/features/experimental/UtilityClass) and [helper](https://projectlombok.org/features/experimental/Helper) classes.

Lombok ameliorates common concerns with the Java programming
language, from "within" the programming language (ie by not formally changing languages as in Scala or Kotlin). Thereby, developers can gain access to the
features they crave, without having to foresake the Java programming language
they know and "love" (for some definition of "love").

````java
// When Lombok compiles, this...
@Value
class MyPojo {
    String string;
    Integer integer;
    Object object;
}
// turns into something
// like this...
final class MyPojo {
    final String string;
    final Integer integer;
    final Object object;

    MyPojo(String string, Integer integer, Object object) { }
    public String getString() { }
    public Integer getInteger() { }
    public Object getObject() { }
    public int hashCode() { }
    public String toString() { }
    public boolean equals(Object o) { }
}
````

[This excellent post explains that Lombok does this by abusing Java annotations and annotation processors](http://notatube.blogspot.com/2010/11/project-lombok-trick-explained.html).
When the Java compiler runs, it offers (what it believes to be) a read-only copy
of the abstract syntax tree (AST) of the Java program to Lombok. Lombok uses its
knowledge of which classes are used in the implementation of some Java compilers
to plumb the API's of the compiler, learn its abstract syntax
tree implementation, and then manipulate the tree to effectively re-write the
in-memory representation of the Java program before compilation completes. It's
a clever trick which results in "extensions" to the Java programming language
without ever writing syntactically invalid Java programs. And as long as you
compile your Java programs using the Java compiler, this works fine. (More on this
later.)

However, Lombok is mildly controversial in the Java/JVM community, for the same
reason. Fundamentally, reaching inside internal compiler calls and making
non-standard modifications to the AST are no-no's. The technical debt here manifests
itself in subtle ways; [when competing annotation processors run](https://github.com/mapstruct/mapstruct/issues/510),
or when [alternate programming languages want to call Lombok](https://stackoverflow.com/questions/11171631/error-compiling-java-scala-mixed-project-and-lombok), they often hit issues.
Those other systems cannot see the Lombok-generated code, and getting them to
play nicely can be challenging.

Probably more Java developers than not would rather take what Lombok has to offer
than deal with its absence; although alternate tools exist for POJO generation,
[such as Immutables.io](http://immutables.github.io/), they are a little more
verbose and a little more narrowly scoped than Lombok, and came along much later.

## What is Kotlin?

You may already recognize [Kotlin](http://kotlinlang.org/) from my previous post, 
["Is Kotlin the New Java?"]({{<relref "is-kotlin-the-new-java.md">}})
In short, Kotlin is a hot new programming language from the folks behind the
[IntelliJ IDEA](https://www.jetbrains.com/idea/) editor.

Kotlin has virtually all of the same features that Lombok enumerated below,
but in a first-class way, because the features are built into a language designed
to support them: [Data classes, default function values, lazy properties, extension methods, null checks, resource cleanup, and much more, just on a getting started page!](http://kotlinlang.org/docs/reference/idioms.html)

````kotlin
// This...
data class MyPojo(val string: String, val integer: Int, val object: Any)
// Also translates to this...
final class MyPojo {
    final String string;
    final Integer integer;
    final Object object;

    MyPojo(String string, Integer integer, Object object) { }
    public String getString() { }
    public Integer getInteger() { }
    public Object getObject() { }
    public int hashCode() { }
    public String toString() { }
    public boolean equals(Object o) { }
}
````

Kotlin doesn't stop there, though. It has many more powerful features which are
impossible to hack onto Java through Lombok:

* [Read-only data structures, for safer API development](https://kotlinlang.org/docs/reference/collections.html)
* [More fluent programming over loops, conditionals, functions, strings, and type-checking](http://kotlinlang.org/docs/reference/basic-syntax.html)
* [Destructuring](http://kotlinlang.org/docs/reference/multi-declarations.html), [operator overloading](http://kotlinlang.org/docs/reference/operator-overloading.html), and [unchecked exceptions](http://kotlinlang.org/docs/reference/exceptions.html)
* A [limited but type-safe macro system](http://kotlinlang.org/docs/reference/inline-functions.html)

One of my favorite and underrated features of Kotlin, which seemingly all modern
languages have now, [is string interpolation](https://stackoverflow.com/questions/44188240/kotlin-how-to-correctly-concatenate-a-string):

````kotlin
val firstName = "firstName"
val lastName = "lastName"
val query = """
SELECT $firstName, $lastName
FROM customers
WHERE $lastName LIKE '%smith%';
"""
````

Another one of my favorite features of Kotlin is its type-safe builders feature (which I
am given to understand is derived from Groovy). For example, the
[KotlinTest](https://github.com/kotlintest/kotlintest) library adds support 
for behavior-driven development _from within Kotlin_ programs!

````kotlin
class MyTests : StringSpec() {
  init {
    "length should return size of string" {
      "hello".length shouldBe 5
    }
  }
}
````

Compare this with some of [the most popular ways of achieving behavior-driven development in Java](https://dzone.com/articles/brief-comparison-bdd), and you get a list of
tools which are either difficult to read/understand/write, require magic text files
in other languages, or _aren't even written in Java_! (Okay, sure, Groovy is better
than magic text files, but it concedes the point that Java is at a huge disadvantage.)

### Why Kotlin?

[As summarized on this thread](https://discuss.kotlinlang.org/t/history-of-kotlin-language/2161/5), the raison d'être of Kotlin is to be a next-generation JVM programming language with fully native bi-directional interop with existing Java programs, with fast compile times and superb IDE
experience. Although Scala, Groovy, and Clojure already each exist, none of them
are ideal fits for interoperating with existing legacy code bases with large
footprints, sensitive responsiveness times, and requirements for fast and easy
tooling and compilation.

As seen in this widget below, (originally pointed out by a colleague), Kotlin
interest surged [in the late spring when Google announced official support for Kotlin on Android](https://blog.jetbrains.com/kotlin/2017/05/kotlin-on-android-now-official/),
and has been steadily climbing ever since.

<script type="text/javascript" src="https://ssl.gstatic.com/trends_nrtr/1243_RC12/embed_loader.js"></script>
<script type="text/javascript">
trends.embed.renderExploreWidget("TIMESERIES", {"comparisonItem":[{"keyword":"/m/0_lcrx4","geo":"","time":"2017-01-01 2017-12-31"},{"keyword":"/m/091hdj","geo":"","time":"2017-01-01 2017-12-31"},{"keyword":"/m/03yb8hb","geo":"","time":"2017-01-01 2017-12-31"},{"keyword":"/m/02js86","geo":"","time":"2017-01-01 2017-12-31"}],"category":0,"property":""}, {"exploreQuery":"q=%2Fm%2F0_lcrx4,%2Fm%2F091hdj,%2Fm%2F03yb8hb,%2Fm%2F02js86&date=2017-01-01 2017-12-31,2017-01-01 2017-12-31,2017-01-01 2017-12-31,2017-01-01 2017-12-31","guestPath":"https://trends.google.com:443/trends/embed/"});
</script>


## What are the differences between Lombok and Kotlin?

Here's where I believe most Java developers' ears pick up. To date, Lombok has
excelled at the POJO use case, and some developers also enjoy its ability to aid
with other types of common application-level boilerplate. Kotlin provides all of
this as table-stakes, and also adds features from many other popular Java tools
and competing programming languages.
As the cost-of-entry, Kotlin requires learning a new formal programming language,
but one which has a very low learning curve and strong compatibility with Java
code. The result is a more enjoyable and consistent programming experience across
the board, as long as you are willing to venture out and try a new programming
language.

To aid with decision-making, I'll provide a table of abbreviated features and of
expanded features, to help see where Lombok provides parity and where it does not.

|Feature               | Total Points | Lombok | Kotlin |
|----------------------|--------------|--------|--------|
|POJOs                 | 5            | 5      | 5      |
|Null Safety           | 3            | 1      | 3      |
|Util/Helper/Delegates | 3            | 2      | 3      |
|val/var               | 2            | 2      | 2      |
|Interop               | 10           | 9      | 9      |
|Total                 | 23           | 19     | 22     |

On its own turf, Lombok and Kotlin are very close. I gave some more points to
Kotlin for null safety; although Lombok has `@NotNull`, it's not the same as
having ubiquitous null safety guarantees throughout the code base. Similarly,
although Lombok has clever delegation/util hooks, they don't compete with how
native and fluent Kotlin's own extensions are. For interop, I deducted a point
from each because of niggling concerns I have. Lombok, as referenced above, 
sometimes doesn't play nice with other tools; Kotlin has nearly flawless Java
interop, but sometimes it's not perfect.

And if we add points for the other features which Kotlin brings and Lombok simply
does not, then the imbalance becomes much more pronounced. For fairness, I did
not do that here; however, that is essentially the operative concern for Java
developers. If you are conservative and think that Lombok is the most extreme
set of features you'd like to ever see be added to the Java programming language,
then maybe sticking with Lombok is a good choice for your projects. However, if
you've been pining for a modern, statically typed and compiled programming language;
a language which provides in a single coherent and fun 
compiler/runtime all the features you want
from a dozen different libraries and tools; and a language which was written
 _by working developers_, _for developers_, then Kotlin is surely your bet!
