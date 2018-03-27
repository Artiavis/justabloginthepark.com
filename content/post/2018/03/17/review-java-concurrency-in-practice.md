+++
title = "Review: Java Concurrency in Practice"
date = "2018-03-17T23:50:00-04:00"
description = ""
tags = ["java", "programming", "software-engineering", "concurrency"]
+++

I was recently assigned to a new project at work, which requires some concurrent
programming. I've long put off investing in any formal Java programming texts,
partly out of thriftiness and partially because none of the professional
programming I've done to date required a formal education/reading of relevant
texts to avoid writing completely incorrect code. Usually in line-of-business
application development, a sub-optimal solution is not _completely incorrect_;
at worst, it wastes CPU cycles. However, when it comes to concurrent programming,
there's three options:

* It's not thread-safe and very obviously not so. Nobody has any misconceptions
  about whether this routine will perform properly in a concurrent context.
* It's definitely thread-safe, and you know you can trust it. The set of such
  programs is actually fairly small; you _usually_ trust that your Java Virtual
  Machine is bug-free, and that its standard libraries are bug-free. Beyond that
  it's a bit of a toss up.
* It may or may not be thread-safe, and even if it thinks it's thread-safe, it
  very well may not be, in subtle ways, which are hard to reason about.

The problems with concurrent programming are that even the smallest mistake may
cause byzantine complications of horrifying consequence, which are difficult or
impossible to clearly reason about after the fact. Compared with costing my firm
millions of dollars in lost revenue, paying $20 for a reference book seems like
the right thing to do. So I went down to amazon.com and bought myself a copy of
{{<asin asin="0321349601" text="Java Concurrency in Practice">}}, henceforth
referred to as "JCP".

I had high expectations, because this book is reputed to be _the_ bible of
writing safe concurrent programs, and is practically considered required reading
for many jobs. There's even a Rich Hickey video wherein he describes how JCP
is a shocking read for those who've never picked it up, and echoes the requirement
to read it:

{{<youtube id="dGVqrGmwOAw" startAt="23m57s">}}

## Review

Suffice it to say, this book deserves the reputation it has. Brian Goetz manages
to be interesting while covering extremely dry material, and he neither skimps
on information nor belabours the point. The book is helpfully divided into four
parts, which I found to be a useful demarcation:

1. "Fundamentals", which should be required reading for all Java programmers.
2. "Structuring Concurrent Applications", useful for defining application-wide
   or framework-wide concurrency concepts.
3. "Liveness, Performance, and Testing", which should be read by all Java
   programmers, but is less critical than reading the fundamentals.
4. "Advanced Topics", which can be considered an expansion of "Fundamentals";
   should be read by anyone writing concurrent libraries or algorithms, but is
   critical reading than "Fundamentals" for general-purpose concepts.

As a languages nerd who also takes a keen interest in low-level details, I
basically jumped straight from "Fundamentals" to "Advanced Topics" before working
my way back through the other chapters. That said, the order is less important
than ensuring the right concepts are learned.

Before I opened this book, I didn't realize what a can of worms the Java Memory
Model (JMM for short) can be. The JMM is a bit devilish in that it makes all sorts
of wonderful guarantees about the performance-safety tradeoff of concurrent Java
programs, _with the caveat that this tradeoff relies on tricky contextual semantics_.
If a Java programmer doesn't know about the contract of the JMM, s/he may violate
concurrency safety in subtle ways, which are never flagged by the compiler.
Only by learning the fundamentals can one safeguard themselves against doing
terrible things; even having read it, it's still all-too-easy to make critical
mistakes.

This was an easy enough read for a Saturday afternoon to get a firm feel for the
basics, and it changed my life (okay fine, my _Java programming life_).
Recommending this book is not a strong enough term; I will chase you down in the
street and chuck this book at your head, if you tell me that you haven't read it
but believe you can write thread-safe Java programs.

## Appendix: Unsafe idioms that don't look obviously wrong

The book has a number of helpfully demarcated examples, indicating safe, dodgy,
and then not-so-obviously wrong ways to do things. Many of these are not obvious
at first glance, so I thought I'd enumerate them for reference.

### Double-checked locking

There's a common but incredibly unsafe idiom in Java code, to do the following:

````java
public class DoubleCheckedLocking {
  private static Resource resource;

  public static Object getInstance() {
    if (resource == null) {
      synchronized (DoubleCheckedLocking.class) {
        if (resource == null)
          // BAD! Without a memory barrier, the object will not be
          // safe to read on threads other than the constructing thread.
          resource = new Resource();
      }
    }
    return resource;
  }
}
````

This idiom can be made safe by introducing a `volatile` boolean flag for using
as a memory barrier,
[as indicated by Guava's `Suppliers.memoize(...)` function](https://github.com/google/guava/blob/e24fddc5fff7fd36d33ea38737b6606a7e476845/guava/src/com/google/common/base/Suppliers.java#L147-L174):

````java
static class NonSerializableMemoizingSupplier<T> implements Supplier<T> {
  volatile Supplier<T> delegate;
  volatile boolean initialized;
  // "value" does not need to be volatile; visibility piggy-backs
  // on volatile read of "initialized".
  transient T value;

  MemoizingSupplier(Supplier<T> delegate) {
    this.delegate = checkNotNull(delegate);
  }

  @Override
  public T get() {
    // A 2-field variant of Double Checked Locking.
    if (!initialized) {
      synchronized (this) {
        if (!initialized) {
          T t = delegate.get();
          value = t;
          initialized = true;
          return t;
        }
      }
    }
    return value;
  }
  // ...
}
````

### Improper atomicity delegation

Many developers mistakenly rely upon individual atomic operations and forget
that per-class atomicity requires transactional atomicity, not merely atomicity
of independent components. JCP has a great example of what not to do:
a "NumberRange" class which is
intended to be thread-safe for testing whether an integer is a prescribed range.
(These days everyone knows to do this using immutable objects, but some people
may not see the mistake either.)

````java
public class NumberRange {
  private final AtomicInteger lower = new AtomicInteger(0);
  private final AtomicInteger upper = new AtomicInteger(0);

  public void setLower(int i) {
    lower.set(i);
  }
  public void setUpper(int i) {
    upper.set(i);
  }
  public boolean isInRange(int i) {
    // BAD! The two "get" calls happen separately
    // and the range can change between getting one
    // and getting the other.
    return (i >= lower.get() && i <= upper.get());
  }
}
````

A safer (and more performant/sane etc.) way to do this is to do as done in the
Kotlin standard library for the equivalent class,
[IntRange](https://github.com/JetBrains/kotlin/blob/e43175b16f68f09ac58000b133c69a0b0c609d2c/core/builtins/src/kotlin/Ranges.kt#L50-L71).
This is safe because the `final` properties mean that things can't change in the
middle of the operation, and that memory safety is guaranteed.

````kotlin
public class IntRange(start: Int, endInclusive: Int) /* ... */ {
  override val start: Int get() = first
  override val endInclusive: Int get() = last
  override fun contains(value: Int) = first <= value && value <= last
}
````

### Leaking synchronized resources to unsynchronized contexts

This one took me by surprise, even though it should not have. It's possible to
accidentally "leak" a guarded mutable resource in an unsafe way, via things
as innocuous as String concatenation:

````java
public class HiddenIterator {
  private final Set<Integer> set = new HashSet<>();

  public synchronized void add(Integer i) { set.add(i); }
  public synchronized void remove(Integer i) { set.remove(i); }
  public void doStuff() {
    // Do some stuff...

    // BAD! Concatenating the set calls toString on it,
    // which requires iterating it, which is not thread-safe
    // because we allow modification in the middle of iteration!
    System.out.println("DEBUG: Current set is " + set);
  }
}
````

The answer here is that _everything_ a class does with its internal state needs
to be wrapped, including otherwise innocuous looking methods like
`equals`, `hashCode`, and `toString`!
