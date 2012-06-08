Zoo
===

Try `gem build zoo.gemspec && gem install zoo-0.0.1.gem`

Then `zoo help`

Create a new project
--------------------

`zoo init "Galaxy Zoo" --domain galaxyzoo.org`

Important files
---------------

### /src/scripts, /src/styles

Files in these directories will be converted with CoffeeScript of SASS, respectively, and output to `/scripts` and `/styles`.

Scripts are [AMD modules](http://requirejs.org/docs/api.html#define). I like to format them [CommonJS-style](http://requirejs.org/docs/commonjs.html).

### /src/scripts/lib/zooniverse

This is a **separate repo** shared across all project front-ends. Don't make any project-specific changes here. If you do need to make changes, make sure you push the back to the origin.

Modules in the library are available under the `zooniverse` root.

**TODO: Make this a Git submodule**

### /assets.json

List third-party asset sources and destinations here. Used with [Grabass](https://github.com/brian-c/grabass/).

### /scripts/lib and /styles/lib

Third party scripts should go here.

Generators
----------

### Model

`zoo generate model Subject` creates `/src/scripts/models/Subject.coffee`.

### Controller (and its view and style)

`zoo generate controller Classifier` creates `/src/scripts/controllers/SomeClassifier.coffee`, `/src/scripts/views/SomeClassifier.coffee`, and `/src/styles/some-widget.scss`.

Development server
------------------

`zoo dev 8080`
