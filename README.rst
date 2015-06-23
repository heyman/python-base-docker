Base Python Docker image
========================

Docker image intended to be used as a base image for python projects.

When building a child image of this base image
----------------------------------------------

* Build context directory is put under /home/app/app
* Creates a virtualenv in /home/app/env from requirements.txt in the root of the build context
* Sets an entrypoint that wil


When running the built child image
----------------------------------

* If anything is mounted in /app, whatever it is will replace /home/app/app (this allows 
  updating of the application code without having to rebuild, push & pull the whole image).
* If /home/app/app/env.sh exists, it will be executed (can be used to set up application 
  specific environment variables)
