+++
title = "How Programming is Like Cooking"
tags = ["programming", "software-engineering", "cooking"]
date = "2016-01-09"
+++

[Peter Naur](https://en.wikipedia.org/wiki/Peter_Nau), 
famous in the programming world for his contributions to 
[ALGOL](https://en.wikipedia.org/wiki/ALGOL_60)
and the 
[Backus-Naur Form (BNF)](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_Form)
notation for expressing grammars,
passed away last week. (For those who are not in the programming world,
ALGOL's grammatical syntax inspired most of today's most popular
programming languages, like C, C++, Java, and Python).
As a very young millennial programmer, I'd of course heard Naur's name
from the BNF notation, but didn't really get to appreciate just how prescient
his work was at the time.

[One of the comments on &ldquo;Hacker News&rdquo;](https://news.ycombinator.com/item?id=10832951)
in response to the news of his passing mentions that his
&ldquo;Programming as Theory Building&rdquo;
is one of the more seminal (if less well-known) early pieces of programming
literature about the practice of software development/engineering as an
industrial pursuit. I checked it out (it's a short read), and it really
resonated with me. I'll highlight some of the high level points below.

For the sake of clarity, I'm presenting this as a cooking allegory.
(Also I'm writing this on Saturday night and I'm hungry.)
Because words like &ldquo;computer programming&rdquo;
and &ldquo;algorithms&rdquo;
can be scary to the uninitiated, I'll use &ldquo;recipe&rdquo; everywhere
here instead.

### Recipes Are About Food, Not Steps

Although recipes are written in steps, the steps are only a process to
get from raw ingredients to a delicious dish. The steps describe
the series of transformations which bring about the desired result.

So too, computer programs are a series of steps a computer follows
to perform some desired calculations. For example, sending a text file
to a printer requires calculating things like letter spacing
and ink placement. But when I click &ldquo;Print&rdquo; on a document,
I am not particularly interested in the intermediate calculations
&ndash; I am only interested in getting my document printed.

### Recipes Reflect an Understanding of Food and Flavors

Any amateur cook (like me) knows that executing a recipe is far simpler
than crafting one. Originating a recipe requires
an intimate and nuanced understanding of flavors, flavor interactions,
cooking methodologies, chemistry, etc., as well as being able to
execute all the steps necessary to bring the ingredients together
into a dish. Furthermore, it requires strong and descriptive writing
to be able to accurately describe the steps required without any
mistakes. This is especially important for difficult and lengthy
recipes!

So too, writing a computer program requires a nuanced understanding
of the problem being solved by the computer program, pros and cons
of various approaches, etc. It also requires the knowledge and expertise
to describe those steps in a manner amenable to execution by a computer.
As problems become progressively larger, in turn they require progressively
more instructions to be described to the computer program. The quality
of the description necessarily must be of increasing quality with
more difficult and lengthier solutions, or else mistakes
may arise during the literal execution of the program steps
([&ldquo;bugs&rdquo;](https://en.wikipedia.org/wiki/Software_bug)).

### Modifying a Recipe First Requires Understanding It

Although probably anyone can add or remove ingredients from a recipe
for a sandwich, not just anyone should change recipes for more challenging
dishes. First one must understand intimately whether the ingredients
are adding up to a special whole, whether there are important chemical
interactions, etc.

For example, my mother taught me a recipe for Macaroni and Cheese which
involves creating a cheese sauce using a sauce base known as a
[roux](https://en.wikipedia.org/wiki/Roux). For those who don't know,
a roux is a sauce base formed from the chemical reaction of flour and
fat cooked together at a *very* specific heat and ratio of fat to flour.
Once prepared successfully, it is generally straightforward to derive
[a number](https://en.wikipedia.org/wiki/B%C3%A9chamel_sauce)
[of related sauces](https://en.wikipedia.org/wiki/Velout%C3%A9_sauce) 
[from the roux](https://en.wikipedia.org/wiki/Espagnole_sauce).
In the case of my family Mac & Cheese recipe, the roux is mixed with
milk and cheddar cheese to produce an orange cheese sauce
(which I highly recommend).

![Roux Cheese Sauce](/img/roux-cheese-sauce.jpg)

The hardest part of my family recipe is properly executing the roux.
Anyone with a knowledge of French cooking knows about roux,
and that the fat and flour are necessary to create it.
However, someone without this knowledge may make a mistake like thinking,
&ldquo;I want a low fat version! Let me use less fat.&rdquo;
This will not end well. Having too little fat will necessarily cause
too much flour taste to linger in the sauce, ruining the dish.
Producing a low fat version of a recipe involving a roux requires making
modifications elsewhere in the recipe. This cannot and will not be specified
in most recipes; understanding roux is beyond the scope of a recipe.

So too with modifying computer programs, a programmer must first understand
the *why* of a program as well as the *how*. Attempting to make modifications
without knowing both will end disastrously. Even if it takes a long time,
it is of vital importance to first understand a program before modifying one.

Furthermore, there may be idioms in both cooking and computer programming
which are taken for granted. In cooking, knowledge of preparing e.g. a roux
may be presumed; in programming, understanding
[design patterns](https://en.wikipedia.org/wiki/Software_design_pattern)
may be taken for granted.


### Programming is More Challenging than Writing Recipes

Although until now, the same concepts were able to describe both cooking
and computer programming, it should be apparent that writing nontrivial
computer programs is more difficult than writing nontrivial food recipes.
A difficult food recipe may require several pages to describe, but
a difficult computer problem may require millions of lines of code
to solve. The challenges of maintaining coherence and maintainability
across such a lengthy &ldquo;recipe&rdquo; should be self-evident.
