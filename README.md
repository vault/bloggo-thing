
Blogg-O Thing
==============

This is a blog application on top of Sinatra. Since it's intended for
single-person use, I didn't want to have to deal with anything like
coding login pages or forms. Rather than that, a public/private key system
is used, and posting is accomplished with a simple script. You can write in
your favorite editor and post it from the command line when you're done.

Everything is stored in CouchDB. It's easy to work with, and its view
system saves us from some logic we would normally have to do client side.
It takes care of everything from pagination to counting. All we do in the
app is transform the data it returns.

One thing intentionally missing from this application is a comments system.
If someone would like to comment on something your write they can email
you, or start a thread on any of the multitude of site's dedicated to
commenting on articles like Reddit or Hacker News..

This is still a work in progress.
