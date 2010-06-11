
Blogg-O Thing
==============

This is a blog application on top of Sinatra. Since it's intended for
single-person use, I didn't want to have to deal with anything like
coding login pages or forms. Rather than that, a public/private key system
is used, and posting is accomplished with a simple script. You can write in
your favorite editor and post it from the command line when you're done.

Storage-wise all posts and user information is stored in simple files. We
keep it simple by just storing everything in memory while the application
is running. A text representation of one person's writing will probably
never exceed a couple megabytes. Even with the little extra overhead
created by extra metadata Ruby stores in Objects, this still pales in
comparison to what's required to even run a simple database.

One thing intentionally missing from this application is a comments system.
If someone would like to comment on something your write they can email
you, or start a thread on any of the multitude of site's dedicated to
commenting on articles like Reddit or Hacker News..

This is still a work in progress.
