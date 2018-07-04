+++
title = "Photoswipe Hugo gallery"
date = "2018-06-24T18:22:04-04:00"
description = "Using Photoswipe.js for a lightbox photo gallery on Hugo."
tags = []
hljs = false
+++

As I've recently gotten
[more]({{< relref "purchased-fuji-x100t.md" >}})
[into]({{< relref "fuji-tcl-x100-ii.md" >}})
[photography]({{< relref "asking-about-camera-advice.md" >}}),
I've been feeling the dearth of a gallery on this site.
While I've recently 
[dusted off my Instagram account](https://www.instagram.com/artiavis/),
I still want to be able to share my better pictures without forcing my visitors
to enter Facebook's internet dragnet. So I started looking at options.

The first, and most obvious choice, was to see about whether I could scrape
photos or photo links from my Instagram and mirror them here. While this
does exist, and there are third-party services who will mirror images for you,
there isn't an easy and standalone way to mirror my Instagram here.
Not being interested in linking individual Instagram posts onto this blog, I went
looking for something a bit less heavy and overwrought.

Ultimately, I found [Photoswipe.js](http://photoswipe.com/), an elegant and
lightweight "lightbox" gallery display toolchain. 
It works using a clever mix of static markup and lazy JavaScript to build a
lightweight gallery of image thumbnails, which get replaced with high-resolution
images as site visitors click through the gallery. In this way, mobile devices
aren't forced to download tens of megabytes of full-resolution images that they
won't necessarily look at. (This scratches my own itch; I often consult my blog
while I'm on my phone, and don't want to waste 1% of my mobile data budget to
quicky check something.)

[As I now do my blogging using Hugo]({{< relref "switched-to-hugo.md" >}}),
I tried looking around for some tools which would help me get on my feet faster.
(While Photoswipe is mercifully free and open-source software, it's not quite a
turn-key solution either. )
There's a couple of examples of this on GitHub, but I ended up going with
[liwenyip/hugo-easy-gallery](https://github.com/liwenyip/hugo-easy-gallery) as
a template, and tweaked things from there.
(There's a helpful demo site set up by Li-Wen [here](https://www.liwen.id.au/heg/)).

Basically, Li-Wen's templates use Hugo shortcodes (macros) to expand an
annotated image link into a Photoswipe gallery stub on a page;
multiple disparate galleries can be featured on a given page, and images can be
strewn all over a page despite being part of a single logical "gallery".
Whenever an image is clicked on, it expands into a lightbox gallery viewer for
the whole page; quite nifty.

One unfortunate side-effect of how Hugo macros work, is that, unfortunatey,
there doesn't yet appear to be an easy way to statically emit HTML and JavaScript
macros for an entire gallery using only a single command. Nevertheless, the
advantages of using self-hosted seems to outweight the slight inconvenience of
needing to maintain the gallery macros (considering that I'm not particularly
prolific).


[You can check out my photo gallery here.](/photos)
