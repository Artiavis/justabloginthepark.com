+++
title = "Saving TiddlyWiki Documents"
date = "2021-01-01T13:34:59-05:00"
description = "Notes on how to simplify saving TiddlyWiki documents."
tags = ["tiddlywiki"]
+++

Using a TiddlyWiki is a tale of two cities:

1. Each TiddlyWiki document is a single HTML file [that contains 100% of its own source code and data](https://tiddlywiki.com/#Quine) and [is compatible with all modern browsers](https://tiddlywiki.com/#BrowserCompatibility) (and operating systems). Therefore, opening and reading a TiddlyWiki couldn't be simpler.
1. On the other hand, editing TiddlyWiki is a bit messy if done without a plugin.
  * _With a plugin_, editing and saving a TiddlyWiki happens "in-place", the same as with a Microsoft Word document (or the like). If I edit `mytiddlywiki.html` from my `Downloads` folder, I can save back to `mytiddlywiki.html` in my `Downloads` folder.
  * _Without a plugin_, editing and saving a TiddlyWiki spits out a _clone of the modified wiki. If I edit `mytiddlywiki.html` from my `Downloads` folder, I can save `mytiddlywiki copy.html`, but I won't be able to save back to `mytiddlywiki.html`.

For that reason, serious users of TiddlyWiki should adopt an app or plugin which allows saving TiddlyWikis in-place.

## For Desktop

For desktop, I got started with [TiddlyDesktop](https://tiddlywiki.com/#Saving%20on%20TiddlyDesktop), which is a special web browser that can open and save TiddlyWikis. This is one of the simplest ways to get started, and works fine, but requires downloading the TiddlyDesktop app.

{{< figure src="/img/2021/01/01/TiddlyDesktopSample.png"
           alt="The TiddlyDesktop app is a simple way to get started."
           caption="The TiddlyDesktop app is a simple way to get started."
>}}

After playing around with that for a few days, I decided to take the plunge with [Timimi](https://tiddlywiki.com/#Timimi%3A%20WebExtension%20and%20Native%20Host%20by%20Riz) instead. For Timimi, I downloaded a Firefox plugin, and a desktop plugin, and the two work together to save wikis from Firefox to the hard drive.

## For Mobile

Things are similar on mobile, but I have to pay the "Apple tax" since I have an iPhone.
[The main solution recommended for iPhone/iPad](https://tiddlywiki.com/#Saving%20on%20iPad%2FiPhone) is to pay $5 to download the [Quine 2](https://apps.apple.com/us/app/quine-2/id1450128957) app, and use that together with a Dropbox account to be able to open and save TiddlyWikis from both desktop and mobile.

First, [I enabled a password on my TiddlyWiki following the official instructions](https://tiddlywiki.com/#Encryption).
This way, the contents of my TiddlyWiki will be safe even if they're stored on the
cloud.

Then, I set up the sync from my desktop. I installed 
[Dropbox's Desktop sync feature](https://help.dropbox.com/installs-integrations/sync-uploads/sync-overview)
to synchronize the TiddlyWiki to Dropbox's cloud.
Then, I moved my TiddlyWiki file from my `Downloads` folder into my `Dropbox`
folder on my desktop computer, and voila! TiddlyWiki in the cloud.

Finally, I downloaded the Quine 2 and Dropbox apps onto my iPhone. As you can
see in the screenshots below, this allows opening and saving TiddlyWikis
from mobile. (I don't plan to do a lot of editing from my phone, but it would
be handy to be able to view things from there.)

{{< figure src="/img/2021/01/01/Quine2AppBrowseDropboxWikis.jpeg"
           alt="Quine 2 allows creating and opening TiddlyWiki documents in Dropbox."
           caption="Quine 2 allows creating and opening TiddlyWiki documents in Dropbox."
           >}}

{{< figure src="/img/2021/01/01/Quine2AppOpenedEmptyTiddlyWiki.jpeg"
           alt="The save button can save TiddlyWiki documents back to Dropbox, too."
           caption="The save button can save TiddlyWiki documents back to Dropbox, too."
           >}}


