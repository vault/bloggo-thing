
This folder is where all the data for the blog is kept.

Users each get their own directory. This is named after their email
address so as to be easy to identify them by. Seeing as this is intended
to be for one person, there should really only ever be one here, but I'd
like for the system to be flexible enough in case I want to let multiple
people use the  blog later.

So, within each users folder, there are a couple of different things. One
is a file called 'userinfo.json'. This file is a simple json file with the
user's information stored as an Object. The two necessary fields are
'email' and 'name'. It should be fairly trivial to add more fields later.

The next important file is 'keys.json'. This is a json array containing all
of the user's public keys. These should all be RSA, as that's what we're
expecting while we decrypt stuff.

There is also a folder called 'posts'. This folder is filled with a json
file for each of the users posts. Each file contains only a JSON-Object with
various fields. The important ones are 'author', 'title', 'body', and
'date_posted'. These are all fairly self-explanatory. There should also be
a field called 'clean_title'. This is important because it represents the
url at wich that post can be found.
