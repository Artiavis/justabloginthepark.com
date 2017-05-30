+++
title = "Returning to Blogging with Cryogen"
tags = ["meta", "clojure", "python"]
date = "2015-10-24"
+++

It's been a long while since I last blogged. My last post dates back to
April of 2014, shortly before I graduated from Rutgers Engineering.
My life since then has been a bit of a whirlwind. I've since graduated,
moved to the Upper West Side, started working in banking, gotten engaged
and married, and moved out. I suppose I could be forgiven for not blogging
as actively.

## Why I Took Down My Old Blog

My old blog was running on [Ghost](ghost.org), a nifty JavaScript-based
modern reimagination of the classic web-based blogging platform. Ghost
has some gorgeous themes, a svelte editing experience, and seems poised
to be the next generation of blogging platforms. It seems great. Why
did I leave it behind?

Unfortunately, there isn't really a free option for hosting Ghost
(at least, that I was aware of). Ghost needs to be hosted on a web
server somewhere. Although this can cost as little as $5 a month to
leave online, I knew that I wasn't going to be able to blog for a long
while and didn't want to bother paying for it while it wasn't in use.
I made the decision to export my data (which Ghost does make fairly
easy) and wait until things might settle down and I would have time
to revisit blogging.

## Why Static Site Generation

Since I took down my Ghost blog, I'd learned a bit more about the blogging
ecosystem. It turns out that, in addition to costing money to host a
blog against a dynamic database, there are also security implications
to hosting a blog on a server. If a &ldquo;live&rdquo; blog is running
on a server, it needs to be running live code while connected to both
a database and an untrusted network (the internet). While a server
running only a blog is probably not at significant risk of compromising
personal information, it's still an unpleasant responsibility to need
to constantly update a server to patch security holes. This is doubly
the case when blogging really doesn't need anything beyond the ability
to publish text files &ndash; blogs can be published using so-called
flat files, for free, and with no security ramifications.

Instead, I'm moving my blog's hosting to [GitHub Pages](https://pages.github.com/),
which hosts statically generated blogs as long as they conform to certain
(relatively easy to meet) criteria.

## Which Static Site Generator?

I already knew I wanted to use static site generation to blog, but I hadn't
yet decided which software to use. A major consideration for me was that it
had to be in a language which I can program in, in case I wanted to hack on the
software or add features. Fortunately, [Static Gen](https://www.staticgen.com/)
is a site which tracks the repositories for all static site generators on GitHub
across all languages. It proved to help me considerably in making my choice.

Although I feel competent in Java, Ruby, Python, JavaScript, and even Clojure,
I knew I could only consider using a generator which was based in either
Python or Clojure.

* Java is obviously to verbose and enterprisey for a simple blog generator

* Although I've programmed in Ruby before, and I do think it's a beautiful language,
  I've struggled enough with managing Python environments to know that I don't want
  to tangle with managing Ruby environments too, if even for something as simple
  as a blog. This makes things tricky, as three of the top static site generators
  (Jekyll, Octopress, and Middleman) are in Ruby.

* JavaScript is a messy language with a messy ecosystem: &lsquo;nuff said.
  Although it has perhaps the greatest profusion of libraries since Java itself,
  the libraries are constantly moving, and the wheel seems to constantly be reinvented.
  I'd also rather avoid tangling with JavaScript if at all possible.
  (Why did I leave Ghost, a JavaScript blogging platform, to just go back to
  JavaScript static site generation?)

### Taking a Stab at Pelican

Since my strongest language is currently Python, and I have a wealth of experience
with the unpleasantness of managing Python environments gained from work, I decided
to try out a Python static site generator first.
A cursory Google search indicated that [Pelican](https://github.com/getpelican/pelican)
seems like one of the best Python generators currently available. I `pip install`ed
a bunch of dependencies and spent several hours trying in vain to hook up the system
with a palatable theme and plugins to incorporate reasonable things like Disqus integration.

Although Pelican seems well designed (the signals for lifecycle events seems especially
clever), I just couldn't hack it together. The default theme is not particularly attractive.
I tried the eponymous and seemingly fully-featured 
[Elegant Pelican](http://oncrashreboot.com/elegant-best-pelican-theme-features)
theme, but couldn't get the site to build properly. In anger I moved on to Clojure.

### Cryogen - a Relatively Simple Clojure Static Site Generator

The first Clojure site generator in the list was [Cryogen](http://cryogenweb.org/),
which appears to be a relatively simple and straightforward site generator.
Although it doesn't have many frills, I like how it's easier to get up and running.
Leiningen generally doesn't present any problems with setting up new applications
with their dependencies, unlike Python/Ruby/JavaScript. And unlike Pelican,
it comes with a clean and pleasant Bootstrap theme out of the box.
The deal was sealed for me when I saw that
[the famous Yogthos](http://yogthos.net/posts/2014-11-13-Cryogen-static-site-generation-made-easy.html)
is a primary user of it.


## Looking Forward

So far, I like Cryogen. Although it takes a couple of seconds to cross-reference my
tags across the site, it's nice that it ships with a fully baked web server,
and has a lean core. Here's hoping it bears me steady through several years of blogging.
