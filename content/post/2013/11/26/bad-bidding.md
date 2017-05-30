+++
title = "Bad Bidding or Avoid Buying Used Stuff"
date = "2013-11-26"
tags = ["economics"]
description = "Lesson on market for lemons and bid price"
+++

As some of you may know, I'm currently in a class on Game Theory in the 
Economics department. I originally signed up because, hey, games, but also 
because I saw 
[A Beautiful Mind](//en.wikipedia.org/wiki/A_Beautiful_Mind_(film)) 
and I wanted to learn a little more about Game Theory. 
(My professor confessed that despite a large number of students taking the 
class because of the movie, the little Game Theory used in the film is actually 
incorrect. Oh well.) I find Game Theory fascinating and it really is a subject 
that people should study, if only because its hyper-rational approach to life 
actually has some applications, in addition to being insightful and stimulating.

In class today, we discussed a fascinating result of Game Theory which follows using only basic Statistics and a novel
perspective on bidding. But first, a preface for those unfamiliar with game Theory.

### Quick Example of Game Theory

For those of you unfamiliar with Game Theory, it is the study of how individuals should make decisions in situations
where each decision has a different payoff and there are potentially many different decisions available. You don't need
to know too much about the basics in order to understand the point of today's post, but I figured I'd share a quick,
illustrative example anyway.

Suppose you want to buy a used car, and there are only two types of used cars &ndash; "lemons", which are bad buys, and
"oranges", which are good buys. Assume that what you would be willing to pay for a used car in either case is still
higher than what the seller wants for it, and obviously, the value of an orange is higher than the value of a lemon.
("Lemon" is slang for an item which is simply worse than it should be; "orange" isn't actually slang but it's used for
the example and to be funny.) If you can't spot the difference between a lemon and an orange, how much should you pay
for a car of unknown pedigree?

Game Theory employs Statistics here and says that you would pay the "expected value" of the car, which is somewhere
between that of a lemon and that of an orange. As long as the seller of both an orange and a lemon is willing to accept
that value, this system works. The _decision_ here was how much to pay &mdash; in this case, that decision could take on
value in a continuum of values between the value of oranges and lemons.


### How Much Should I Pay for My Friend's Used Laptop?

Suppose your friend is getting a new laptop and is offering to sell you his old one for the right price. His old laptop
happens to be a MacBook Pro, which "as everyone knows", generally holds its value well. However, if it's in particularly
bad shape, it may only be worth a couple hundred bucks. Without owning it yourself, you won't know whether it's really
in good shape, or if he's just selling you a half-working piece of junk. In theory, for the right price, the laptop
could be worth something. What price should you quote your friend for his laptop, keeping in mind that if he doesn't
like your quote, he'll just reject you outright?

Let's assume his laptop is equally likely to be worth anywhere between $400 and $800. (For the mathematically inclined,
this is a continuously uniform random variable.) This means that the laptop is **at most** worth $800, and most likely
is worth less; similarly, the laptop is worth **at least** $400, and probably more. Statistically speaking, in such a
situation you expect that the value of the laptop is evenly in between, which is $600. Does it make sense to bid $600?
Actually, we can use a statistical trick here to show that bidding $600 may not be the best idea.

You only want the laptop if it's for the right price, but your friend will only sell it to you above the value he
secretly knows it's worth. _You can only win the laptop if the bid is for more than (or equal to) what your friend
thinks it's actually worth!_ Suppose you bid $600 and won &mdash; that implies that it was really worth less than $600,
or else he wouldn't accept the bid! In such a case, your best guess for what he thinks the laptop is worth is somewhere
between $400 and $600. You can then expect that it was worth around $500. Using this form of backwards-induction, you
see that you should bid $500 from the get-go, and not $600 as one may assume.

To say this in a slightly more mathematical fashion, suppose the value of something is between 0 and 1. The ex ante
assumption of a price, based only on the information about the price range, is that it is worth 0.5. However, there is
one more piece of information which allows you to further narrow the price range. This piece of information is the
knowledge that in general, an acceptable price would mean that you are also overpaying. This knowledge is used to argue
that 1/2 is probably too much if it were acceptable in the first place, and that 1/2 should be the upper limit. These
two factors combine to allow you to guess that it would be 1/4.

(Some with a background in Calculus fall into the trap of assuming that this logic is circular and eventually reason
(that the guess would eventually hit 0. It's important to note that this argument is neither circular nor recursive,
(although establishing this requires an appreciation of Sets. In probabilistic terms, the "information" that one
(normally wins when his bid is too high is an **Information Set** with only _one_ piece of information. This information
(set can be used _once_ to reason that the bid should be lowered down to 1/4. In order to lower it again, say to 1/8,
(one would need _yet another_ piece of information, which is not available.)

This phenomenon of paying less than you would naively expect something to be worth is called 
[shading](//en.wikipedia.org/wiki/Bid_shading), and is used to combat the phenomenon known as the 
[Winner's curse](//en.wikipedia.org/wiki/Winner's_curse). 
The Winner's curse is the observation that in general for common-value auctions, the winner has overpaid because his
supposition of the value of the item is higher than those of his fellow bidders. Shading is the strategy of trying to
bid less than one guesses an item item is worth in anticipation of winning. If a bidder wins with shading, he didn't
really quote his original price anyway, and he makes off with a bargain (in his eyes); if he loses, he's spared having
overpaid.

Although this doesn't apply in all types of auctions or in all situations, it's useful to keep in mind. **TL;DR: Always
quote someone a price less than you think it's worth when you only have one shot and you pay your price.**
