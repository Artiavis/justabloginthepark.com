+++
title = "Switching to Hugo Blogging"
tags = ["meta", "python", "clojure"]
date = "2017-06-03"
+++

I recently decided to switch the backend static site compilation toolchain for
this blog from the small [Cryogen project](https://github.com/cryogen-project/cryogen)
in [Clojure](https://clojure.org/) to the venerable [Hugo](https://gohugo.io/)
project written in [Golang](https://golang.org/). Although I had previously
written that I wanted a hackable static site generator at
[Returning to Blogging with Cryogen]({{<relref "returning-to-blogging-with-cryogen.md">}}),
my requirements lately have changed.
I thought I'd write a couple of quick notes about why I switched (and why I didn't).

### hackableToolchain &lt;&lt; maintainableToolchain

An easily hackable blog generator became less valueable to me than a robust and well
maintained one. Although it was nice getting to contribute code to Cryogen and to
make a difference, and to be able to understand the code base, the value of established
and battle-tested code is something I ignored at the time. (I knew it was a factor,
but at the time I just wanted to get rolling quickly. These days I'd rather have
something that works on its own.)

### Windows is Actually Supported

I had two independent issues happen while working with static site generators in
other languages that turned me off of them and towards Hugo:

1. It transpired that essentially everybody
   working on Cryogen was writing on *nix machines and some of their file manipulation
   API's failed in egregious ways on Windows. Although this is partially a,
   &ldquo;Don't mess around with filesystem paths using regexes&rdquo; issue, the fact that
   there weren't more eyes on this was a major turn off.

1. I tried helping a semi-technical literature-inclined friend get started with
   static site generation on Windows. I thought to recommend the most beaten-path toolchain recommended in the general community, so I attempted to help him install 
   [Jekyll](https://jekyllrb.com/) using the [Chocolatey](https://chocolatey.org/)
   Windows package manager. This turned out to be quite a misadventure; seemingly
   the folks using Jekyll are all either hacking away on *nix machines too (see above)
   or are master hackers who know how to compile binary extensions using custom toolkits
   on Windows (this is something that took me multiple days to figure out when I was
   hacking on Rails back in the day!). Neither of these approaches are friendly to
   beginners on all platforms; and ignoring Windows or treating it as a byzantine
   oddity are not acceptable to me.

Although neither of these stories are the fault of the toolchain maintainers
(file manipulation API's on the JVM are iffy in general and although scripting
languages like Python/Ruby are svelte for writing blogging software, they're
not always easy to get working on Windows), they make it difficult to recommend
their respective platforms. Having a single binary to install without external
dependencies or complex toolchains (cough [Hakyll](https://jaspervdj.be/hakyll/))
is essentially the easiest thing to recommend.

### &lsquo;Smart&rsquo; API's Available in Posts

An annoyance I had before was my desire to easily cross-reference posts that
were either explicitly or implicitly part of a series. This is really something
which should be supported as a first-class concept in the blogging toolchain,
but which is also technically foreign to the 
[Markdown language](https://daringfireball.net/projects/markdown/)
within which most posts are written. Either the author of posts needs to manually
cross-reference (error-prone and obnoxious when this is something which should
be easily accessible within the blogging software), or extend the language.

Although I wasn't aware of this feature previously and it wasn't originally a
motivating factor to adopt Hugo, it turns out that
[Hugo actually has first-class support for cross-references](https://gohugo.io/extras/crossreferences/).
For example, the way I've cross referenced the previous article about Cryogen
looks something like this:

````markdown
[Returning to Blogging with Cryogen]({{<relref "returning-to-blogging-with-cryogen.md">}})
````

As shown here, I still must explicitly declare the link, but there is a macro
of sorts which will evaluate and return the relative post path, enabling first-class
cross-referencing support. The fact that this is available is a major boon.

### Ease of Use Trumps Foreignness 

The last time I had gone through this exercise, I was only willing to consider
toolchains in languages that I both knew and which were easily scriptable.
Looking at my previous post, it transpires that the platforms I was willing to
entertain were:

* Java, only to dismiss it for being too kludgy &ndash; I may yet revisit this
  if I become very desperate/masochistic
* Ruby, considered but dismissed on technical considerations
* JavaScript, dismissed because I'm still leery about all things Node.js
* Python, which I had struggled with and set aside
* Clojure, which I got working due to its simplicity and the fact that I already
  had bought into the language at that time

At the time, I didn't discuss anything on .NET (and I still don't 
take it too seriously for blogging software), Haskell, or Golang, which
ruled out Hakyll and Hugo. The motivation for omitting the latter was essentially
that since I couldn't program in those and that I wasn't willing to learn simply
for the sake of blogging, that they should be left out.

I've changed my mind. Although I still don't want to touch Golang myself until
they figure out their story with generics, I am sufficiently convinced in Q2-2017
that Golang is going to stick around that I'm willing to use a toolchain written
in it. Right now, I think that Hugo is the only blogging toolchain which is both
flexibile out-of-the-box and which has the &ldquo;just works&rdquo; edge.
