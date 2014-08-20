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

   plackup -s Starman bin/app.pl

