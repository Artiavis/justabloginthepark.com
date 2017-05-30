+++
title = "IaaS and PaaS Explained: A Food Analogy"
tags = ["programming"]
date = "2015-11-22"
+++

The other night, I was meditating about my various options for deploying
applications at work, including
[&ldquo;Infrastructure as a Service&rdquo; (IaaS)](https://en.wikipedia.org/wiki/Cloud_computing#Infrastructure_as_a_service_.28IaaS.29)
and
[&ldquo;Platform as a Service&rdquo; (PaaS)](https://en.wikipedia.org/wiki/Cloud_computing#Platform_as_a_service_.28PaaS.29).
Amidst my musing, I came up with an analogy for explaining the difference
between these various ways of deploying programming solutions,
in addition to the much more conventional approaches which were used
formerly (and are often still necessary).


## The Analogy

Suppose you want to get into the food services industry. You have many
decisions to make, but chief among them is deciding two related things.

1. What type of food are you serving?
2. In what space/through which medium do you serve that food?

If you want to serve cotton candy, you certainly don't need a large
restaurant with plenty of floor space. Similarly, if you wish to serve
filet mignon with fine wine, a food truck is probably not going to cut it.

Although some restaurateurs do find success with creative takes on these
models (perhaps serving steaks in sandwiches out of the back of a truck?),
there are certain combinations which simply will not work out well
(filet mignon out of the back of a truck probably won't be appealing to many).

I contend that there are four models which work in both food and deploying programs.

1. You rent or own the entire space, exclusively for your own business.
2. You rent a small portion of a "shared" space. Think of a combined
   Dunkin Donuts and Baskin Robbins sharing the same common facilities.
3. You rent or own a food truck. You have no major infrastructure limitations
   and can easily move from location to location, as long as you can continue
   to find hospitable places to do business.
4. You partner with a distribution company to put your food into a vending
   machine. You don't have to worry at all about electricity, rent, gas,
   temperatures, supply chain, etc. You hand over your packaged goods
   to someone else, and they take responsibility for everything else.

### The Conventional Model: You Own the Space

Can you imagine eating a sumptuous steak dinner at a cramped table for two
at a fast food dining joint, or standing up outside of a grease truck?
Probably not. If you want to present customers with the fine dining experience,
you can't help but to completely "own" (in a style sense, if not a business one)
your entire space. You simply cannot guarantee with absolute certainty that
the dining experience you present to your customers will match your desires
with 100% certainty unless you own 100% of the space of the restaurant, and
see to 100% of the decor as well.

This is probably the most classical of the dining business models listed
above. You simply cannot get more conventional than running a business
where you own your space and make all of the decisions for yourself.
The equivalent of this with deploying software solutions would be owning
(or renting entirely for yourself) an actual (physical) server. You own the
machine, and you get to make every decision about what goes on it, how it
runs, how it talks to other systems in your business, etc. If you need to
exact the utmost of performance and customization from either your restaurant
or your application, you probably need to own the space and keep it for
yourself.

### A Modern Model: Shared Spaces

![Shared Baskin Robbins and Dunkin Donuts](/img/combined-baskin-robbins-dunkin-donuts.jpg)

Not all businesses need to customize every little thing about their spaces,
or need to be available at all times of day all at once. Many eateries
can conceivably do most of their sales in certain well defined hours,
and share their spaces to save on overhead. A common model I've seen often
is for a Dunkin Donuts (coffee, bagels and doughnuts) and a Baskin Robbins
(ice cream) to share the same, small fast-food dining space and kitchen.
I presume that Dunkin Donuts does most of its business for breakfast and lunch
hours, while Baskin Robbins serves its desserts more towards the mid afternoon
and dinner hours. They both are "light" food businesses without severe need
for cooking space (their food is largely not cooked on premises), which can
have the same quick sit-in dining experience. Why not share the space and cut
down on costs? Does either business really need all the costs associated with
sole ownership of the space?

This is similar in model to the
[Virtual private server (VPS)](https://en.wikipedia.org/wiki/Virtual_private_server)
model of hosting programmatic applications. Lightweight applications which do
not need to endure high load (or which have high load during times which
do not interfere with other neighboring applications) can be hosted in
partitioned spaces within a single server. It's as if you "owned" the entire
server in that you can customize your area for your needs, but it's still
shared in that you should be a nice neighbor.

### The Portable Pick-Up and Go Model

Sometimes, your eatery has a different set of requirements than simply
not needing a large cooking space. Maybe you need to seasonally have many
more locations; maybe you need to relocate too often to bother with
settling down in any one place. For those eateries which desire flexibility
and can fit their food into a small space, a grease truck can really get the
job done.

To really nail this home, suppose you run an ice cream business. During the
winter, you probably aren't selling much, so you may only want to have a
single truck in town. But during the summer, you probably want to have half
a dozen trucks in town. During peak days, like holiday weekends or heat waves,
you can even potentially double your number of trucks! It's all about meeting
demand with supply.
If you're able to easily rent trucks when you need
them, you may gladly pay a
[liquidity premium](https://en.wikipedia.org/wiki/Liquidity_premium)
to pick up the surging demand. To be clear, you still can't serve steaks out
of the back of a truck, even if you wanted to; conventional, demanding models
require you to own your space. But if you're a Dunkin Donuts or a 
Baskin Robbins, operating out of the back of a truck is an extremely viable
alternative.

Companies like [Amazon](https://aws.amazon.com/ec2/) and 
[Google](https://cloud.google.com/compute/) host services offering this
flexible scaling with servers (instead of ice cream trucks).
This model is known as
[&ldquo;Infrastructure as a Service&rdquo; (IaaS)](https://en.wikipedia.org/wiki/Cloud_computing#Infrastructure_as_a_service_.28IaaS.29).
Maybe you don't want to tie your application down to a server, or even
a VPS. Perhaps you need to dynamically add new servers on-the-fly
during a busy day, and you want to be able to effortlessly take
them offline afterwards. IaaS allows you to respond flexibly to demand,
at a cost. This flexibility is often worth the price difference over
simply sharing space with a VPS, as mentioned above.

### If Your Model is Truly Trivial&hellip;

As discussed above, a steakhouse is highly unlikely to be operating in a food
court or out of the back of a truck. But even a doughnut shop might struggle
with this final area: vending machines. For those types of food that are
so simple that they need no preparation and can be kept indefinitely at any
number of convenient locations, to be accessed at will, a vending machine
is actually potentially more flexible than any of the aforementioned options.
To be clear, not only can't you get steak from a vending machine, you aren't
to get any number of other flexible foodstuffs: like falafel, sandwiches,
shawarma, salad, and so on. But if you just want to serve soda bottles,
ice cream, or candy, you can't beat the simplicity of wrapping your food up
and sticking it into a vending machine. 

Companies like [Heroku](https://www.heroku.com/) provide this service for
deploying applications, known as
[&ldquo;Platform as a Service&rdquo; (PaaS)](https://en.wikipedia.org/wiki/Cloud_computing#Platform_as_a_service_.28PaaS.29).
PaaS is similar to a vending machine:

* If your product is simple (doesn't need special preparations or involved storage)
* If your product can be packaged up and forgotten until it's wanted
* If your product can be packaged into a way that's friendly for
  self-service hosting

If your application is relatively trivial, like a blog, hosting it on a
a PaaS is a great option. PaaS's provide many of the same flexibility options
that IaaS provide, such as being able to very quickly bring new servers online
and take them down just as quickly.
(In fact, Heroku's PaaS is hosted on Amazon's IaaS!)


### You Need to Make A Choice

Suppose you have a flexible product, like ice cream. You can have your own
restaurant. You can share a space. You can sell it in trucks. You can even
sell it in vending machines! How do you decide which medium to use?
You need to make a choice &ndash; you need to sell your ice cream *somewhere*.
Ice cream doesn't sell itself, after all (although it almost does&hellip;).

So too with application deployment, it simply is not possible to deploy
without choosing a deployment channel. Although it's tempting to think of an
application as a neat little black box that can go anywhere, you still need
to make a decision about the channels you use to host your application.

Hopefully this set of analogies offered a novel perspective on how VPS,
IaaS, and PaaS work, and illuminate the process of choosing one to host
an application. Please leave your thoughts below!
