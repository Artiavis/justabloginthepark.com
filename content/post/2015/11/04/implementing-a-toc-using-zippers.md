+++
title = "Implementing a Table of Contents Using Zippers"
tags = ["programming", "clojure"]
date = "2015-11-04"
+++

As I continue my forays with Clojure, I'm finding it enjoyable (if not entirely
productive) to hack with it on 
[Cryogen](https://github.com/cryogen-project/cryogen), a nifty little
blog generator 
[I already discussed recently](/posts/2015-10-24-returning-to-blogging-with-cryogen.html).

On Sunday I had the privilege
[of making my first pull request](https://github.com/cryogen-project/cryogen-core/pull/51).
The essence of the PR was to fix a
[couple of bugs](https://github.com/cryogen-project/cryogen/issues/62)
with the existing implementation of the logic for generating a Table
of Contents for a given blog post, and also replace a less robust
algorithm (for real-life use cases) with a more robust one.

### The Gist of the Problem

When writing a lengthy document or article with several subsections,
whether in print or digitally,
it's helpful to provide a table of contents (TOC) to provide shortcuts to
relevant information and to clue the reader to document structure.
Whereas a physical volume or document might consist of several
explicit and distinct chapters or sections,
a web page instead generally has sections implicitly declared through
the use of larger or smaller header tags (denoted in HTML with
any variety of the sequence `h1 h2 h3 h4 h5 h6`). (It's important to
stress that header tags are generally used for *visually indicating*
the section's content significance, and don't strictly signify the
presence of a section, a subsection, a sub-subsection, etc.)

Naively, a document with three sections, each with nested subsections,
should wind up with a TOC which looks like the following:

<table class="table"><tr>
<thead><th>Structure of Document</th><th>Appearance of TOC</th></thead>
<td>
```
h1. Introduction
    h2. Exposition
    h2. Problem Statement
h1. Proposed Solutions
    h2. Solution 1
    h2. Solution 2
h1. Conclusion
    h2. Takeaways
```
</td>
<td>
<ol>
<li>Introduction</li>
<ol><li>Exposition</li><li>Problem Statement</li></ol>
<li>Proposed Solutions</li>
<ol><li>Solution 1</li><li>Solution 2</li></ol>
<li>Conclusion</li>
<ol><li>Takeaways</li></ol>
</ol>
</td>
</tr></table>

This is all well and good &mdash; we have a beautiful table of contents
which perfectly mirrors the document structure!

On the other hand, what if you want a structure wherein there are only
two solutions enumerated in small headers, and then a slightly larger
takeaways header? Something like this?


<table class="table"><tr>
<thead><th>Structure of Document</th><th>Appearance of TOC</th></thead>
<td>
```
h2. Solution 1
h2. Solution 2
h1. Takeaways
```
</td>
<td>
<ol>
<ol><li>Solution 1</li><li>Solution 2</li></ol>
<li>Takeaways</li>
</ol>
</td>
</tr></table>

As alluded to earlier, header tags are meant to convey visual effect
in addition to (in)directly denoting the presence of sections of a
document. However, in the event that an author prefers a larger
and more pronounced choice of header for a conclusion paragraph than
in introductory paragraph, should the earlier headers be naively indented
in the same way as they were above? Probably not.

### Problem Statement

The problem, then, is as follows:

> A document should be able to have its headers appear in any order, but still
  maintain a consistent level of indentation in the table of contents. Any
  top-level header should be at the outermost indentation level of the TOC,
  even if the value of those headers are different.

Visually, this organization should be respected:

<table class="table"><tr>
<thead><th>Structure of Document</th><th>Appearance of TOC</th></thead>
<td>
```
h2. Solution 1
    h3. Aspect 1
    h3. Aspect 2
h2. Solution 2
    h4. Elaboration
    h3. Complications
h1. Takeaways
```
</td>
<td>
<ol>
<li>Solution 1</li>
<ol><li>Aspect 1</li><li>Aspect 2</li></ol>
<li>Solution 2</li>
<ol><li>Elaboration</li><li>Complications</li></ol>
<li>Takeaways</li>
</ol>
</td>
</tr></table>

## The Algorithm

### The Old Algorithm

The naive algorithm for generating a table of contents was roughly as follows:

1. For each header in the document, if that header is of smaller/larger size
   than the previous header, add/subtract levels of indentation representing
   the difference in their magnitude.
2. If it turns out levels of indentation were completely skipped
   (e.g. from two levels of indentation straight to four, with nothing
   in between), reduce indentation so that there are no sudden jumps.

The problem with this algorithm is that it doesn't robustly handle the case
where larger headers are used for conclusion paragraphs than with intro ones.
The visual indentation which would result is still unattractive and not
representative of a reader's expectations.

### The New Algorithm

The new algorithm I decided upon was strictly informed by my opinion that the
visual consistency of the TOC is more important than strictly indenting
each heading the number of times its value might suggest. As noted above,
I expect and want to see all subtopics nested, but anything which does
not appear to be a sub-topic should be at the outermost level of indentation.

This, then, is the algorithm:

1. The first header in the document is always at the outermost level of
   indentation. Have a symbolic root-level tree node which doesn't have
   any values. Start here.
2. Compare a node to be inserted against the current, reference node.
  - If the reference node is either the root node or greater in value
    than the node to be inserted, append it as the last child of the
    reference node.
  - If the reference node is equal in value to the node to be inserted,
    insert the node after the reference node.
  - If the reference node is not the root and is lesser in value than the
    node to be inserted, go back to step 2.
3. After inserting a node, use the inserted node as the new reference node
   and go back to step 2, until all nodes are inserted.

Although this is a bit tricky to describe, it actually flows naturally.
Any time a header level decreases, add a level. Any time a header level
increases, subtract levels until it fits.

### Implementing with Zippers

#### What is a Zipper?

Clojure [implements a really funky but cool data structure to manipulate trees](https://clojuredocs.org/clojure.zip/zipper)
called a
[zipper](https://en.wikipedia.org/wiki/Zipper_%28data_structure%29).
Zippers are essentially cursors over trees. Put another way, a zipper
can be thought of as a little magic lens which "zips" up and down,
left and right, bit by bit through a tree. The zipper acts as a lens
onto/into the specific element at its location, permitting all the usual
access and modification rules to that element. The zipper also is aware
of its location within the tree by internally holding references to sibling
and parent nodes (and trivially having access to a node's own children).
As the zipper drills down through the tree, element by element, it "zips"
the layers of parent nodes into its memory, so that it can "zip" back up
through the tree at its convenience.

Zippers are extremely powerful and generally necessary when doing functional
programming using functional, immutable programming languages like Clojure
because it would be unfeasible to modify trees otherwise. If, every time
an insertion, update, or deletion needed to be done deep within a tree,
a brand new tree with the root of that tree got returned, it would be very
difficult to efficiently update deeply-nested trees. Zippers allow efficient
tree operations by holding the location within a tree while modifying it,
so that the position in the tree isn't lost during modification.

#### Applying Zippers to the Table of Contents Problem

I'll confess that the main reason I was interested in the use of zippers
for the Table of Contents problem is their ability to hold the position
of a tree. The primary property that makes our Table of Contents
algorithm work is that each header to be added must be compared with either
the previous one (if it's slated to be inserted at the same level) or the
one above it (if a candidate for un/nesting). This is exactly what zippers
provide! By being able to zip up, I can always compare a node to be added
against its prospective parent, without ever losing track of my position
within the tree.

The actual code [can be found here](https://github.com/cryogen-project/cryogen-core/blob/365df0e6806a432c82f9dd37d0f1eab8f4f7e16f/src/cryogen_core/toc.clj#L23-L61).
Note that the algorithm itself is implemented trivially in terms of the
existing API provided by the zipper type:

* Building the TOC tree consists simply of iterating through the headers and
  inserting them into the tree
* The insertion routine simply zips to the appropriate place in the tree,
  inserts the header, and uses that location as the new reference
* Zipping to the right place is a simple application of the decision tree
  described above.

## Retrospective Analysis

Although it took a while to get the hang of the Zipper data structure and its
API, I found that having access to it really made this algorithm simpler to
implement and understand. I also found that learning about the zipper helped
me understand the Lens data structure as well. In another post, I'd like to
review some of the interesting nuances of the Zipper API, and how it appears
that a form of object-oriented design was elegantly achieved.

## References

* [Documentation on the Zipper function](https://clojuredocs.org/clojure.zip/zipper)
* [The blog post which helped me grasp zippers](http://www.exampler.com/blog/2010/09/01/editing-trees-in-clojure-with-clojurezip)
* [Wikipedia](https://en.wikipedia.org/wiki/Zipper_%28data_structure%29)

