Zoo
===

Installation
------------

Try `gem build zoo.gemspec && gem install zoo-x.y.z.gem`.

Then `zoo help` should work.

Create a new project
--------------------

`zoo create Galaxy Zoo`

You can set the domain with `--domain`. It'll assume it's `(projectname).org`.

Important files
---------------

### /src/scripts, /src/styles

Files in these directories will be converted with CoffeeScript of SASS, respectively, and output to `/scripts` and `/styles`.

Scripts are [AMD modules](http://requirejs.org/docs/api.html#define). I like to format them [CommonJS-style](http://requirejs.org/docs/commonjs.html).

### /src/scripts/lib/zooniverse

This is a Git submodule shared across all project front-ends. **Don't make any project-specific changes here.** If you do need to make changes, make sure you push the back to the origin before you and update and commit the parent's repo.

Modules in the library are available under the `zooniverse` root.

### /assets.json

List third-party asset sources and destinations here. Used with [Grabass](https://github.com/brian-c/grabass/).

Update an asset by changing its source in the file and running `grabass update jquery`, for example.

### /scripts/lib and /styles/lib

Third party scripts should go here.

Generators
----------

### Model

`zoo generate model Subject` creates `/src/scripts/models/Subject.coffee`.

### Controller (and its view and style)

`zoo generate controller SomeWidget` creates `/src/scripts/controllers/SomeWidget.coffee`, `/src/scripts/views/SomeWidget.coffee`, and `/src/styles/_some-widget.scss`.

Development server
------------------

`zoo serve 8080` runs an HTTP server with CoffeeScript and SASS watchers in the right places.

Clone an existing project
-------------------------

`zoo clone Repo-Name`

You can also give it a directory.

Set the user with `--user`. The default is "zooniverse".

Set the branch with `--branch`. The default is "master"

Build a project for deployment
------------------------------

`zoo build` produces a directory containing everything needed for the site to run.  You can also pass in a name for the directory (like "beta").

Deploy to S3

`zoo deploy` does not work yet.
