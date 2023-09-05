Base Python Docker image
========================

Docker image intended to be used as a base image for python projects.

When building a child image of this base image
----------------------------------------------

* Build context directory is put under /home/app/app
* Creates a virtualenv in /home/app/env from requirements.txt in the root of the build context
* If a package.json i present in the root context it (together with any package-lock.json) will 
  be copied to /home/app/app and npm install will be run


When running the built child image
----------------------------------

* If anything is mounted in /app, whatever it is will replace /home/app/app (this allows 
  updating of the application code without having to rebuild, push & pull the whole image).

