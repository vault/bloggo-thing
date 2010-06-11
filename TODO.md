
Todo
=====
* Views (**Major!**)
* Attachments
* Make it pretty (**Major!**)
* multi-user support

Let me elaborate a bit on this. 

Views
------
Currently we have an extremely basic index view, and a blank view for
individual posts. Obviously these need to be elaborated on. It shouldn't be
particularly hard, I just haven't bothered implementing them.

Attachments
------------
This one will be trickier, and is also fairly important. We'd like to be
able to upload pictures and the like to the site without much hassle. This
is going to have to be a two-step process: One client side, and the other
server side.

Client side we'll have to read through the body of the post looking for
image links and the like. We'll have to decide if a link points to a local
file, in which case it needs to be uploaded to the server (probably
encrypted in the same way as the posts). Server-side will then have to store
that file in such a way that it can be accessed in the same way that it was
described client-side.

While this is relatively important, it's not too major if it doesn't get
done soon. If I need to include a picture for the time being, I'll just
host it elsewhere and include the link to it like that. Odds are I won't be
posting too many pictures anyway.

Make it pretty
---------------
CSS it until it screams when confronted with the irrefutable fact of its
own beauty. This may take some work.

Multi-user support
-------------------
A basic framework for multiple people posting exists already. The only
problem that I can really see at the moment is if two people post an
article with exactly the same title (or titles close enough that they get
normalized to the same thing). At present that really won't hurt things too
much, it's just that the last one to be read will be the one that the
article's url will point to. This is also not too important of a goal at
the current time.
