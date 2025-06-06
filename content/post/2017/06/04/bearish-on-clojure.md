+++
title = "Bearish on Clojure in 2017"
tags = ["programming", "clojure"]
description = "Musings on a recent controversial essay about the state of Clojure in 2017 and what it means for Clojure's community and Clojure programming in practice"
date = "2017-06-04"
+++

There was a recent brouhaha in the Clojure community about 
[the recent blog post](https://lambdaisland.com/blog/25-05-2017-simple-and-happy-is-clojure-dying-and-what-has-ruby-got-to-do-with-it)
by a Clojure dabbler to the effect that Clojure may be a clean and beautiful language
but that it fails in a few pragmatic and ergonomic senses which hurts its adoption
and limits its appeal. Although the author admits that he probably made a mistake
in jumping to adopt Clojure, a foreign technological concept to him,
for a startup in a space that was also completely foreign to him, he does bring
up some worthwhile points that are worth chewing over.

## Clojure's Paltry Introduction for Beginners

It is a well-known issue in the Clojure community that getting started with
Clojure is extremely difficult for both beginners to programming, as well
as to those without hardcore programming experience. Here are just a few
of the challenges beginners face:

### Development Environment Setup is Non-trivial

 Getting a development environment set up is non-trivial, to say the least.
 Although the [Leiningen](https://leiningen.org/) project is excellent
 at helping individuals install and bootstrap a working Clojure environment,
 getting libraries installed and launching a REPL, Leiningen (on its own) 
 does not help would-be developers learn the Clojure development experience.
 Although there are a few environments that somewhat simplify the experience,
 they are all imperfect in various ways:
 
 * [Cursive](https://cursive-ide.com/) is a plugin for IntelliJ IDEA which 
   provides third-party support for Clojure within an existing IntelliJ
   installation (even the free version). This is one of the most fully-featured
   IDE's for Clojure. However, it suffers from the fact that it's a plugin
   within an existing IDE (which means finding and configuring it is more difficult),
   and that you must learn quite a bit about configuring IntelliJ itself in
   addition to Cursive. As IntelliJ is a heavy-weight Java IDE, learning Cursive
   is not for the faint of heart for programming/JVM beginners.

* [Cider](https://cider.readthedocs.io/en/latest/) is a plugin/mode ecosystem
  for programming in Clojure in Emacs. This is a well-maintained, highly polished,
  very deep mode for Emacs and it works well. However, like Cursive (in its own way),
  it requires very deep buy-in for a beginner. Emacs can take an extensive period of
  time to learn, and because Cider fancies itself as an Emacs-native environment
  within Emacs, it is probably impossible to use Cider without first/concurrently
  learning Emacs. (I understand there is a similar project for Vim called
  ["Fireplace"](https://github.com/tpope/vim-fireplace)
  but I believe it uses the same backend as Cider and requires
  equal buy-in to Vim, which is even less beginner-friendly than Emacs.)

* [Light Table](http://lighttable.com/) IDE was actually developed in a dialect
  of Clojure ([ClojureScript](https://clojurescript.org/)) and comes fairly close
  to being a fluent Clojure IDE. However, Light Table is not actively developed
  or maintained, and is not a production-level IDE for anything, let alone for
  Clojure. It's good for introductions but is not really something a Clojure
  developer should invest heavily in.

* There is a project similar to Light Table called [Night Code](https://github.com/oakes/Nightcode),
  which is a cute Swing-based Clojure IDE written in Java which attempts to be
  a Clojure-specific starter IDE (like Light Table) but with more templates.
  Night Code is nice in that it has templates for creating new projects, and it
  is aware of your code so that you can connect to it. However, like Light Table,
  it is not a true IDE, and is not ideal for serious Clojure coding.

In short, there is nothing for Clojure like there is for Java/C#/Python/Ruby - no
dedicated, standalone IDE which can be installed and out-of-the-box support
Clojure with simple documentation and a straightforward learning curve from
beginner usage to being able to develop production apps. This limits Clojure's
appeal because beginners either must be veteran e.g. Java programmers moving onto
Clojure with their existing JVM and IntelliJ knowledge; or they can experiment
using the lightweight editors, but will not learn about techniques like debugging
and refactoring, which will make advancing to higher levels of programming more
difficult.

### Opaque or Bizarre Error Messages

I won't spill much (digital) ink on this point because it's both rather well
known, and also an area of active research (although not finished yet). Clojure
is a Lisp (an interpreted, dynamic language) canonically hosted on the Java virtual machine
and written in Java (which is yet another interpreted, dynamic language, albeit
one with a compilation phase which reduces the dynamics of the language at runtime.)
When an error happens in Clojure, for performance reasons, the error is caught
by the runtime of the JVM, which knows nothing about either Clojure or why this
embedded language allowed this error to occur. This results in an awkward
dichotomy for both veteran JVM programmers new to Clojure, as well as general
beginners:

1. If the error is due to a misuse of JVM constructs or a mistake in writing
   Clojure code, the error will probably extensively mention JVM types, but will
   actually be an error in the usage of the Clojure language. These errors can
   be recognized with experience but are not always clearly called-out.

1. If the error is due to a mistake in the usage of a Clojure API, the Clojure
   runtime will _sometimes_ call this out, but often, a Java stack trace is also
   printed, which confuses the issue of where the error lies. (In this case it
   is almost universally in the usage of the API's within syntactically valid
   Clojure, but to a beginner that nuance is blurry at best.)

There are no perfect solutions here, due to the dynamic and interpreted nature
of Clojure. One catch-all approach with horrifying performance implications for
production code is to add several layers of parsing, validation, and error reporting
to all Clojure code, to catch and clearly elucidate the first variant of error,
as well as to present less ambiguous messages for the latter error type. Because
Clojure envisions itself as a production-friendly language, adopting these expensive
runtime checks is out of the question.

The approach the authors of Clojure seem to be embracing is to introduce a static
type-checking runtime to be bolted-onto the language, called
[`core.spec`](https://clojure.org/guides/spec) (inspired by Typed Racket).
The idea is essentially to enable developers to toggle a flag in the runtime to
indicate whether to perform extensive validations and type-checking at the language
level, and if so, to validate API's. 

* For beginners, this will provide friendlier errors without any real loss, since
  beginners are unlikely to be notice performance losses due to validations.
* For developers using a development-to-production pipeline, this allows developers
  to validate their logic without hurting performance in production.

Although `core.spec` is a clever way to attempt to have one's cake and eat it
too, it isn't the panacea that some hope it would have been.

* It is fairly late to the game (ten years after the language first debuted)
* It's unclear when it will land in the core runtime, which is fairly important
  for beginners who shouldn't be expected to independently install such an
  important module
* It still can't catch issues where Java/JVM API's are misused or invalid Clojure
  code is constructed (both of which would probably still emit cryptic error
  messages to beginners).

## Clojure Values Conceptual Purity Over Developer Happiness

This point in the author's essay relates to a popular but also mildly controversial
talk given by Clojure's author, Rich Hickey, titled
[&ldquo;Simple Made Easy&rdquo;](https://www.infoq.com/presentations/Simple-Made-Easy).
Rich argued for designing clean API's which do not introduce unnecessary complexity
at a runtime/language/library level, even if doing so required making
development less &ldquo;pleasant&rdquo; or &ldquo;easy&rdquo; for developers
(for some definition of those words). This can be differentiated almost directly
to a language like Ruby, which permits all sorts of hacky modifications to the
runtime in the interest of developer ease, despite potentially complicating
the runtime and API surface.

This core value is an essential part of Clojure's mission statement. It's
impossible to imagine Clojure, with its clean API's and nearly-fanatical avoidance
of impurity, without this concept front and center.

However, this concept and its ramifications arguably also reflect on the difficulty
of setting up a nice Clojure code base. Although ActiveSupport does terrible things
to the Ruby runtime, the ability for a beginner to type code like `2.days_ago`
and get a meaningful result is breathtakingly joyous. Compare that to having to
call a Clojure wrapper over a Java time API like
`java.time.ZonedDateTime.now().minusDays(2)` using something like
`(.minusDays (java.time.ZonedDateTime/now) 2)`, which requires learning that
Java has multiple datetime libraries, that Java 8's libraries are better than
both `java.util.Date` and Joda time, etc.

Clojure and its community generally prefer writing libraries and glueing them
together by hand, rather than having a framework like Rails that has some sensible
opinions that bypass the bikeshedding and let developers ship business logic.
Although it's nice that Clojure apps can be pure because libraries are invoked
manually, it's not nice to beginners that they must teach themselves all of web
programming and how to safely and properly wire up calls, when Rails has done
this out of the box for over a decade.

## Clojure's Primary &ldquo;Killer App&rdquo; is Proprietary

There is an argument out there that languages become popular because they have
one or more &ldquo;killer apps&rdquo; written in them which motivate developers to
flock to that ecosystem. Ruby obviously had Ruby on Rails; in recent years,
Python has had many numerical analysis and machine learning libraries such as
Numpy, Pandas, Scikit-Learn, and TensorFlow. Although Java doesn't have any
one killer app, it's both an established enterprise player, as well as host
to most of the Apache applications (each of which is itself a killer app).

(Although [Apache Storm](http://storm.apache.org/) is an honorable mention as a
production quality Clojure application, it does not technically count for two
reasons. First, the project was before-its-time and appears less popular than both
Apache Spark's Streaming and Apache Flink, neither of which are true streaming
solutions and both of which post-date Storm. Second, although Storm is primarily
written in Clojure, its API's are heavily buried in Java API's to the extent that
most users are probably unaware of its Clojure implementations.)

Rich Hickey and Cognitect developed a killer app in and for Clojure &mdash; the
distributed database system [Datomic](http://www.datomic.com/). Datomic is an
attempt at creating a Datalog-powered fact-database, albeit one with clever
locking, distribution, and caching mechanisms baked in. Datomic is truly elegant
in that it handles distributed reads/writes/locking, maintains an immutable
history (enabling audits and time traveling), caches in client memory (e.g. no
separate cache layer required), and that it bakes in its own ORM (if you're okay
with all your objects looking like Clojure maps).

However, Datomic is an exclusively commercial offering. This does partially make
sense; it relies upon backends like AWS, and its appeal as a database is to those
who would want its powerful enterprise capabilities and its all-in-one nature.
However, it's a loss for the community that such a powerful and motivating app
sits behind a paywall. If people had to pay for Ruby on Rails, it's arguable that
both Ruby and Rails would not be where they are today; but the fact that they were
both free meant that a community rapidly formed around Rails, _even despite the fact_
that it was written in Ruby. If both Clojure and Datomic were completely free,
more people might flock to Clojure to be able to more easily consume Datomic.

## Clojure's Maintainers Do Not Communicate Enough

There was another Clojure controversy which managed to span nearly a year:
[introducing tuples to Clojure](https://dev.clojure.org/jira/browse/CLJ-1517).
[Zach Tellman](https://github.com/ztellman), a prominent Clojure library author,
attempted to contribute a patch to Clojure to provide some data structures which
he believed would be more performant and optimal for Clojure's runtime. After
nearly nine months of discussion and waiting for consideration, Rich Hickey
(Clojure's author) turned around and made his own tweak without informing Zach
and without bringing him into the discussion until after the change had already
been shipped. Although he made strong technical arguments for doing things his
way, his behavior was not the kind you would expect from a gracious open source
contributor. 

[Zach eventually wrote an essay expressing his sentiments about the Clojure development model](https://medium.com/@ztellman/standing-in-the-shadow-of-giants-9ac52f8b4051).
It may not be fair to characterize what transpired as backroom-cigar-parlor
planning on the part of Hickey/Cognitect, but it definitely flies in the face of
the spirit of modern open source software to have an openly visible code base
but a closed development model. If open source contributors can't be treated as
proper contributors and have proper discussions with the language maintainers
as code develops, then the code base is clearly not open, despite its source
being made available. It would be more honest in this case for Clojure's
maintainers to officially announce that bug fixes may be accepted but that feature
requests and code reviews may and probably will be rejected at an unspecified
future date.

## Where to Go from Here?

I still think Clojure is one of the most elegant languages I've ever worked with,
and I think that it's still a true beauty to work with once you've gotten going
with it. However, between a steep learning curve, lack of open-source killer apps,
lack of bidirectional openness with the community, and a lack of fun Clojure
libraries which speak to developer happiness, I do tend to agree with the assessment
that Clojure is stagnating (I ultiamtely disagree with the author of the article and
wouldn't go so far as to say it's dying). With modern and fun languages which
give many of the same benefits of Clojure but with easier learning curves and
cleaner and easier experiences such as Kotlin, Elixir, Golang, etc., Clojure
couldn't really afford to play things out the way it did. I'll continue to keep
an eye on Clojure and see where using it makes sense; but I suspect it's already
lost the war of developer interest (and my own, for now).

## References

* [The instigating blog post](https://lambdaisland.com/blog/25-05-2017-simple-and-happy-is-clojure-dying-and-what-has-ruby-got-to-do-with-it)
  * [Analysis of that post on Reddit](https://www.reddit.com/r/Clojure/comments/6d9say/simple_and_happy_is_clojure_dying_and_what_has/?ref=share&ref_source=link)
  * [Analysis of that post on Hacker News](https://news.ycombinator.com/item?id=14418013)
* [LispCast episode pondering whether Cognitect, Clojure's author's company, should do more for Clojure](http://www.lispcast.com/cognitect-clojure)
  * [Analysis of that post on Reddit](https://www.reddit.com/r/Clojure/comments/6dbkys/should_cognitect_do_more_for_clojure/?ref=share&ref_source=link)