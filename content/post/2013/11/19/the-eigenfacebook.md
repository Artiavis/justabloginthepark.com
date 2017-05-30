+++
title = "The Eigenfacebook"
tags = ["dsp", "programming"]
description = "Wherein my classmates and I endeavor to create a facial recognition system using basic signal processing techniques"
date = "2013-11-19"
+++

The end of the fall semester is always a very special time of year. The hubbub
of plans for winter break are omnipresent, festive lights illuminate themselves
around campus, and most importantly of all, professors finally get around to
assigning all their term projects with scarcely three weeks left with which to
complete them. This isn't news to my fellow upperclassmen, although the
sophomores may only just begin to experience this for the first time.

In my _Digital Signal Processing Design_ course with the amazing [Dr.
Rabiner](http://cronos.rutgers.edu/~lrr/index_old.html), we learned about the
basics of both Digital Image Processing and even certain rudimentary ideas
behind Speech Recognition and Synthesis. As a sort of small capstone of taking
the class, we subdivide into groups of three and attempt to tackle a small
Matlab project which seems interesting to us. My friends Craig, Cory and I
decided (in no small part because the two of them happen to be in a course on
_Computer Vision_) to make a face-recognition program. Face recognition is often
achieved using a mathematical construct known as an
[eigenface](//en.wikipedia.org/wiki/eigenface); and of course, everyone has
heard of Facebook. Put them together and you get **_Eigenfacebook_**!

### What's an Eigenfutz?

The idea of an Eigenface is actually fairly intuitive. When you look at a photo
of a person you know, you can generally recognize them. However, if the lighting
was bad or you had only met the person once or twice, you can still usually
recognize him or her by facial features. Long nose, prominent jawline, high
cheekbones, strong eyebrows, etc. This approach, while it may be a 'fallback'
for normal people, is actually also the approach used by computers to recognize
headshots of people.

The computer stores a database of photographs of various people's faces (a
headshot), including a previous photograph of a person you intend to recognize.
To recognize someone in the database, you present the computer with another
photograph of the person. The computer starts by comparing each photograph in
the database against the database's "average" photograph to find what makes each
headshot unique from each other one features differ from average, and does
likewise to the given photograph. The computer then chooses the photograph from
the database which most closely resembles (in a [Euclidean distance
sense](//en.wikipedia.org/wiki/Euclidean_distance)) the given one, and claims
that the person in the given photograph is the matching person from the
database. This approach has a few strong advantages, although it suffers from a
few weaknesses as well.

1. Because each photograph in the database is compared individually, a score can
be created which measures just how "good" a match is. You can say that if a
score is too bad, it shouldn't match up against any face in the database.
Furthermore, you could even say that if the score is really awful, you may not
even be looking at a human face! (See the humorous reference figure at the
bottom of [this page](//www.cs.princeton.edu/~cdecoro/eigenfaces/).)

2. This approach is non-statistical, which means that it doesn't matter whether
there's five photographs  of a person in the database of five-thousand (although
more than just one is ideal because of possible singularities in only one
image). Whichever single database photograph matches most closely will be all
that's necessary to identify the person. This differs from many other systems
which strictly require many hundreds or thousands of reference data points in
order to make a prediction.

3. This program, as described, is quite naïve and does not make assumptions
about whether the given photograph is of a face, an arm, a leg, a tomato, or a
potato. It only aims to compare it against the database and possibly make an
identification. Even though a good implementation will ignore tomatoes or
potatoes, there is another subtle implication. All the headshots need to be
taken in similar lighting, with the face in a similar position, with a neutral
background and in neutral clothing, and using the same resolution camera (or at
least image). Otherwise, the faces in the photographs won't be clearly
identifiable to the computer, and a great deal of confusion could occur.


#### Real-world Applications

This technique is actually extremely powerful &ndash; it's the technique used
for both facial and iris recognition. So why not use it for logging people into
their smartphones or favorite websites? In fact, 
[Android has already been doing this for almost two years as of this post](http://www.android.com/about/ice-cream-sandwich/#face-unlock).

### Results

Although we didn't get as far as actually logging people into their own Facebook
accounts using this technique (although it is a fun idea for a hackathon), we
demonstrated the concept by making Matlab greet a person who successfully
scanned in with Eigenfacebook.

In our implementation, we had a few observations. First, things in the
background, even as innocuous as colored walls or objects, had an appreciable
impact on the recognition capabilities of the program. Likewise things in the
foreground, such as patterned shirts (I'm looking at you Craig!), could cause a
false positive for the reasons stated above, and so should try and be avoided
(or cropped out of the photograph). Finally, taking photos with our faces at
varying distances from the camera, surprisingly enough, was also enough to
confuse the program. Seemingly different magnifications of the same face
compared to other faces could also be mistaken when compounded with other
factors.

We tried to combat most of those issues by projecting a circle onto the webcam
we were using as a kind of frame to line up against. This helped us crop the
photo closely to avoid getting much background noise, and also allowed us to get
a consistent magnification of photographs.

#### References

A special thanks to [Christopher de Coro](//www.cs.princeton.edu/~cdecoro/index.php), whose
[notes](//www.cs.princeton.edu/~cdecoro/eigenfaces/) on the Eigenface technique
illustrated the compact procedure in Matlab.

Find the code on [Github](//github.com/Artiavis/theeigenfacebook).
