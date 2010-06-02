
Blog Thing
===========

This is a blog application on top of Sinatraa and CouchDB. Since it's intended
for basically one person, I didn't want to have to deal with anything like
coding login pages or forms. Instead, we do things with cryptographic mumbo-jumbo,
(semi-unrelated, ruby's OpenSSL documentation is horrible).

We used to use keys and certificates, but it's slightly easier to just use keys. We now
just encrypt the data over the wire, along with the email of whoever is posting.
Look up the email addres in the db, and see if any of their keys work to decrypt it.
If so, we assume it was from them and post it. If not, we give back error codes.

That's all there is to it. We have a rudimentary display of posts, but nothing 
especially impressive. It's a work in progress.
