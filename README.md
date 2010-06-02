
Blog Thing
===========

This is a blog application on top of Sinatraa and CouchDB. Since it's intended
for basically one person, I didn't want to have to deal with anything like
coding login pages or forms. Instead, we do things with cryptographic mumbo-jumbo,
(semi-unrelated, ruby's OpenSSL documentation is horrible).

Here's how it works. On your machine, you have a private key and a certificate.
To post to the blog what you do is send a POST to the root URL. It should have
two params: 'sig' and 'data'. 'data' is JSON. It has two fields, title and
body. The sig is a digital signature for the data. The server checks that the
public key of the signature matches the public key of the user stored in the
database identified by their email address.

Currently that's all there is to it. I haven't written the views yet, so there's
not much else to check. This may or may not actually be secure...
