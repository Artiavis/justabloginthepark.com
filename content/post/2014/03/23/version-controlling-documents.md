+++
title = "Version Controlling Documents"
tags = ["writing"]
date = "2014-03-23"
+++

As a college student (and despite studying Engineering), I'm occasionally required to write paper for class. Sometimes
they're simply one-off papers that only need to be a page or two (like for my Ethics class), in which case it doesn't
really matter what I write the papers in or whether I back them up in any meaningful capacity.  In theory, if the worst
happened and I lost the file, I could rewrite it in a couple of hours and it wouldn’t be the end of the world. The
lion’s share of the effort invested would have been on the ideas, and a similar paper could be rewritten in even less
time.

This only applies to garden variety &ldquo;What do you think about X?&rdquo; questions. I am definitely not so cavalier
about lengthier papers, which seem to come up once a semester. The legendary tales of graduating seniors or graduate
students losing final copies of their theses fill me with dread, and so I seem to compulsively hit Ctrl + S every half
minute or so when editing documents. But what can one do against such calamitous events? It’s not as if we get two
weeks’ notice that a disk will fail. Compulsively uploading half-baked versions of things to Dropbox would get tiring
pretty quickly.

![Computer Crashed, Lost Files](/img/computercrash.jpg)

### Cloud Storage as Failsafe

Actually, there is a way to accomplish this automatically. (I sometimes do this when I don’t feel like bothering with
the method I describe next.) Many are familiar with using 
[Dropbox](https://www.dropbox.com/downloading?src=index) (or
[OneDrive](https://onedrive.live.com/about/en-us/download/), or 
[Google Drive](https://tools.google.com/dlpage/drive/)) as cloud storage. But not everyone knows that it’s possible to download a
program from each of these companies which creates a folder on your computer which automatically live-synchronizes to
its respective cloud. (I currently keep two on my computer, Dropbox and OneDrive, so I can have one which I don’t use.)
Then, instead of writing your document in your Documents folder (which tends to be people’s default), you write your
document inside that synchronized folder. Every time you save (or shortly thereafter), the document will be magically
pushed into the clouds. (Just be warned that the process which keeps its eyes peeled for changes to the folder also
tends to drain battery life rather quickly on laptops, or so I’ve heard.)

### Cloud Storage for Versioning

A powerful feature which not many people seem to be aware of is that many of the cloud storage providers also 
provide versioning, too. Accidentally save over your essay with a cat poster and lose hours or days of work? You can 
usually go into the cloud and ask for the previous version of your file back. Take, for instance, 
[Dropbox’s Packrat feature]( https://www.dropbox.com/help/113/en). For free, and automatically, every file gets a 30 
day history which can be unwound as needed to recover lost or otherwise FUBAR’d files. For a cost, it can be an 
indefinite history. This is nice for the paranoid, but I imagine most people who accidentally overwrite a file will 
realize **before** a month passes. 

However, even this may not be enough for the truly demanding writers (ie my friends who are writing their senior theses,
a yearlong endeavor). When someone needs to juggle half a dozen different concurrent edits of a lengthy paper and keep
track of both differences between major drafts and incremental changes within those drafts, relying on cloud versioning
as a nifty hack simply won’t cut it.

One way of tackling this issue is with 
[Microsoft Word’s merge feature]( http://www.wikihow.com/Merge-Documents-in-Microsoft-Word). 
One can have a few files which contain the major differences between drafts, 
and use the merge features within Word to highlight the differences between files. 

![Microsoft Word Merge File Differences](http://www.wikihow.com/images/3/3c/MergeDocumentsWord6.jpg)

### Welcome to Real Version Control

When I write extended length papers, I personally rely upon a tool which offers full granularity between both
incremental changes as well as major drafts: version control systems (VCS for short). In a VCS, whenever a user wants to
create a snapshot of a directory, a user &ldquo;commits&rdquo; the directory into the VCS. However, a user can actually
have multiple concurrent &ldquo;timelines&rdquo; of a directory. (These are called different names in different systems,
but since I like the 
&ldquo;[Git]( http://en.wikipedia.org/wiki/Git_(software))&rdquo; 
VCS I’ll use its term: branches.)
The best part is each branch can exist concurrently, be merged back into a &lsquo;master&rsquo; branch, but still be
continuously developed independent of other branches. I actually learned about VCS from my programming adventures, but
it's so powerful there's no good reason it can't also be applied to writing documents which need granular control (à la
theses). Also there are nice tools which can visualize the state of the versions of the directory, as in the beautiful
example below by [Vincent Driessen]( http://nvie.com/posts/a-successful-git-branching-model/).

![Git Branching Diagram by Vincent Driessen](/img/git_branching_diagram.png)

As evident in the diagram, different branches can be spawned off and merged back in freely. This can be especially
useful if you want to consider taking a paper in multiple different directions from a common base, and end up needing to
reconcile them all back into a common starting point.

This actually happened to a friend of mine sophomore year. He was publishing an academic paper to be published in a
peer-reviewed journal, and his adviser actually micromanaged him so closely that he was juggling half a dozen different
drafts of his papers at every stage of the process. At the time, he didn’t know about VCS, and so he struggled to
manually keep track of the different versions of his drafts, which became an exhausting exercise. As each draft was
finished, the adviser returned its predecessor-by-two covered with edits. He then needed to reconcile the new draft and
the old draft while moving forward with another draft which then had to be reconciled with the then-current draft. As he
later told me, he would have killed to have known about VCS then.

