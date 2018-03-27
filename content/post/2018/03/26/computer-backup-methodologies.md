+++
title = "Computer Backup Methodologies"
date = "2018-03-26T22:58:22-04:00"
description = "In which Jeff discusses what he considers to be the three primary ways of backing up computers/data."
tags = ["computers", "technology", "tech-support"]
hljs = false
draft = true
+++

I was chatting with my dad the other day, and the topic of backing up computers
came up. At the moment, he uses the "Time Machine" feature built into his aging
MacBook Pro to do backups of his hard drive. However, his Time Machine is backing
up to an already tired external USB hard drive, and he's now at the point where
both his laptop and his USB hard drive are at risk of keeling over whenever.
What should he be doing in his situation?

Although I'm not an IT guy, I play one on TV, and quickly discussed the three
main options, as I see it today, for backing up personal computers for "typical"
types of home computer users. (This includes folks who are into most forms of
non-technical hobbies, but not necessarily professional videographers or
home supercomputer enthusiasts.)

**[TL;DR: If you want advice on what kind of backup solution to consider, use this link to skip to the summary table, then skim back up as necessary.]({{< ref "#summary" >}})**

## Option 1: local OS image backups

The first family of options is also the oldest and most conventional.
Rely on the tools built into your operating system to create restore points of your computer
_but put them onto an external drive you won't lose or break_.
macOS (formerly OS X) has (in my opinion) the better backup option in its
"[Time Machine](https://support.apple.com/en-us/HT201250)" utility (which, for
nerds out there, is apparently just `rsync`
with some hard links thrown in). Although Time Machine is getting on in years,
it still works effectively at what it needs to do, and at any rate there's no
superior option in this category. Windows _used_ to have one way to do it, which
was "[System Restore Points](https://support.microsoft.com/en-us/help/17127/windows-back-up-restore)",
but as of Windows 10, now has a _second_ way to do
backups, which seems to just be called 
"[Backup](https://support.microsoft.com/en-us/help/17143/windows-10-back-up-your-files)".
(If I had to guess, I think the reason why Microsoft encourages the new, second
option over the first option is that the system restore points were opaque,
confusing, heavy-weight, slow, and did not easily expose the file-restore
functionality many people expect from OS image backups).

Once any of these tools are set up, your operating system will recognize a
certain external drive as being a backup disk, and whenever that disk is
connected to your machine for a non-trivial length of time, the operating system
will automatically and transparently begin backing up onto it. For both Time
Machine and System Restore Points, even a brand new machine or a cleanly
reinstalled machine, could theoretically back up from one of these images. This
makes them very handy for bouncing back from a lost/stolen/broken machine,
_which highlights the importance of regular backups_.

{{< figure src="/img/2018/03/26/classic-ancient-usb-hard-drive.jpg"
           alt="A classic, ancient USB hard drive which may have been used for OS backups."
           caption="A classic, ancient USB hard drive which may have been used for OS backups."
>}}

However, as if to make this even harder, the cheapest and most obvious
way to backup is also the
easiest way to mess it up - using USB external hard drives which are easy to lose,
easy to forget to plug in, and which break just as quickly as a laptop!
Don't get me wrong, having a backup is better than having _nothing at all_, but
_how much better_ than nothing at all is another matter entirely.

Suppose you have a four-year-old laptop and a four-year-old USB external hard
drive, and furthermore you've been diligent and been backing up the laptop to
the USB external hard drive via Time Machine/System Restore Points fairly
regularly. Unexpectedly, your laptop crashes, and you need to restore the OS
onto a new computer from the old USB hard drive.
_What are the odds that, having never attempted the restoration before, your one hard drive, which is just as old as your laptop, and far cheaper, happens to be able to perfectly restore everything?_

Case in point, after we scrapped my wife's old laptop, we took a look at her old
USB external hard drive. Although we were able to get all her files off of it
(and we're both reasonably sure they're pristine as well as unconcerned if not),
we started experiencing gremlins trying to use the hard drive for other machines.
It seems that it was halfway to giving up the ghost already, and that we were
fortunate enough to be able to get to it before it was gone entirely!

Thus, while OS backups can make sense for some people in some situations, they're
easy to mess up, and have gotchas which I haven't already gotten to, including:

* Your external hard drive can get lost/stolen/break independently of your machine.
* Your have no backup of your backup, which leads to an awkward chicken-and-egg problem if you want peace of mind.
  (Would you want to store your life's savings or family photos on a machine with only one backup?)

I'm being harsh on OS image backups because they're so easy to mess up, which
makes them less suitable for some people. They can be made to work, 
and are (in some ways) most cost-effective for
"infinite-storage backups", but by and large are phasing out in popularity.
At home, I use [one of Synology's j-series](https://www.synology.com/en-us/products/series/j)
Network-attached storage devices, so that all the family's machines can be backed
up via WiFi, with effectively infinite backup sizes.

![](/img/2018/03/26/synology-ds216j.jpg)


## Option 2: Cloud OS image backups

With the advent of fast internet connections and public cloud technology comes
options for backing up a copy of your OS to "the cloud". (For those who don't know,
"the cloud" is a no-longer-new phrase for referring to any given internet-hosted
colossal amorphous fleet of computers run by a company/organization, for purposes
of giving flexible, cost-effective, remote computing resources to people who
aren't themselves colossal amorphous organizations.)
The nice part of using cloud-based backup solutions is that they skirt many of
the thornier aspects of backups which typically stump lay users:

* Lay users often don't know or can't be bothered to follow the IT "Rule of Three",
  which posits that for any important data, there should be at least three copies,
  and one of those copies should be physically outside the place you keep your
  original and your primary backup. There's a couple of reasons why the
  "Rule of Three" is hard for a typical person to follow:
  1. It's "expensive" in dollars and cents -- someone has to pay for three disks
     when only one disk is needed for the computer.
  1. It requires work and setup -- keeping the off-site backup requires having
     safe-deposit box or a friend/relative's house in which to stash the off-site
     copy. The fact that the other copy has to be physically removed from the
     primary computing site (ie home) makes it work to get to. Paradoxically,
     the geographically further the off-site backup is, the safer it is, but also
     the more onerous to get in case something catastrophic actually does occur.

Many people are perfectly content to keep all their photos, videos, documents,
and settings on a single computer, as long as they can operate in the good faith
that were a cataclysm were to occur, they could still get everything back;
in other words, they want insurance and peace of mind, without the expense of
maintaining physical machines.

To this challenge has risen a number of companies, 
[the current top contender](https://www.tomsguide.com/us/best-cloud-backup,review-2678.html)
of which is "[Backblaze](https://www.backblaze.com/cloud-backup.html)".
(Full disclosure, I use Backblaze for my "Rule of Three" off-site NAS backups,
but don't currenty use them for personal cloud backups.)

The basic gist of using Backblaze (or anything like it) is as follows:

1. You open up your wallet and pony up around $50/year to subscribe to their "service",
   and run their program on your machine.
1. Their unobtrusive program occasionally checks for changes to your computer,
   and when it sees them, encrypts (and probably compresses) them and sends them
   over the internet to their "Cloud". (You can set it up so that not even they
   can read your data, by using an encryption key,
   but if you do that, you're on your own if you forget the
   password you used; they are incapable of resetting it if you do that.)
1. In a best case scenario, you never need to use Backblaze for restorations.
   You paid them $50, which you won't get back, but it's simpler and easier than buying and
   testing and maintaining an unlimited supply of USB external hard drives anyway.
1. If you _do_ need to restore, you have two options (as of the time of this writing):
   1. You can get back a moderate amount of data over the internet. This is useful
      in case you want to get back some documents, but don't need to restore everything.
   1. If that's too little data or too slow, they can mail you a hard drive, for
      restoring everything in bulk. There's a deposit-style model, where you can
      pay $189 for a drive to be mailed to you, but you can get the money back if you
      return that drive within 30 days.

For your $50/year, you get peace of mind, unlimited data backups for a single
computer (plus all hard drives), and can offload much of the burden and cost of maintaining
the required technology to someone else.

## Option 3: Cloud file backups


## Summary

If you have a PC or laptop at home which you don't back up, you should really get
on that! Odds are, if you aren't already doing the backups, the best thing to do
would be to use either Backblaze (or a competitor) or Dropbox (or a competitor),
depending on your needs. I've put together a little summary table to help with
those decisions.

Use case               | Local OS backup | Cloud OS backup     | Cloud file backup
-----------------------|-----------------|---------------------|----------------------
Back up documents      | Fair to Great   | Fair to Good        | Excellent
Back up photos[^photo] | Great           | Good                | OK up a point, but expensive
Back up videos[^video] | Good            | Fair                | OK for a couple, gets expensive fast
Back up OS settings    | Great           | Good                | Almost useless
Back up everything!    | Great           | Great               | Mediocre at best
Annualized cost        | $20-40/TB       | $50/"unlimited"     | $100/TB[^cloud-file-plans]
Effort required        | Moderate        | Very low            | Very low to moderate, depending on use

As shown in the table, the annualized cost of using a USB hard drive for backing
up may seem low on paper, but fails to account for the human costs associated with
manually curating backups. As such, using local backups should be primarily done
for those with large photo/video collections, who need to keep files handy. Otherwise,
cloud backups tend to be more economical in terms of both time saved, and optimizing
for various price points.

[^photo]: For the sake of argument, I include a discussion of how effective these solutions are at backing up photo libraries. However, it's true that increasingly many people rely upon "free" (as of the time of this writing) cloud backup/management solutions like [Amazon Prime Photos](https://www.amazon.com/Cloud-Drive-Storage/b?node=13234696011) or [Google Photos](https://photos.google.com/). For those who eschew the "free" solutions, or who have large personal catalogs that they enjoy working with locally, including this section is still cogent.
[^video]: Video files are so large that it's actually not a good idea to store them in any of these options; that being said, if you insist on doing so, which of these options are the best.
[^cloud-file-plans]: There's quite a bit of competition in this space, which means that there tends to be a variety of price points and free-tiers for thrifty shoppers. Companies like Google, Apple, Dropbox, Microsoft, Amazon, and others all compete in the fairly crowded file-cloud solution space. In fact, I remember that when I was in university, the standard wisdom was for all the students to open up trial with each; in the end, everybody seemed to have something like 10-20GB of free file storage, which is plenty for most students.

Do you think I missed anything, or have comments to add? Feel free to leave a note
in the comments below!

## Appendix

I'm a big fan of technology blogger Scott Hansleman, and he has quite a few
blog posts which themselves are treasure troves of wisdom on IT resilience and
backup options. Some of my favorites are:

* [Is Your Stuff Backed Up? Recovering From A Hardware Failure](https://www.hanselman.com/blog/IsYourStuffBackedUpRecoveringFromAHardwareFailure.aspx)
* [The Computer Backup Rule of Three](https://www.hanselman.com/blog/TheComputerBackupRuleOfThree.aspx)
