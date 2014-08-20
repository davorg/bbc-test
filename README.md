BBC Technical Test
==================

Dave Cross - dave@mag-sol.com

The video authorisation app has been implemented as a simple Dancer
application.

Notes
-----

1. Not enough tests (there are never enough tests)
2. The authorisation service has been implemented as part of the same web app.
3. Because the main app calls the authorisation app, the app can't be run
   using Dancer's default development web server (which is single threaded).
   Therefore you need to run the app using a multi-threaded server. I used
   Starman, like this:

   `plackup -s Starman bin/app.pl`

Questions
---------

Some things I would have asked the product owner:

1. How is the authorisation id generated? (I just use a random number)
2. When does the authorisation duration start? (I assumed now)
3. How is the authorisation duration calculated? (I used one hour)
4. What action should the history href take? (I did nothing useful)

All of these assumptions are hard-coded, but can easily be replaced when
the questions are answered.

(Oh, and I know that substituting variables in text string is a *terrible*
way to generate XML. My next step would probably have been to replace that
with XML::LibXML or something like that.)
