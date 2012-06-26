Zoo
===

Installation
------------

Clone it and make sure you're on the "app" branch. Try `gem build zoo.gemspec && gem install zoo-*.gem`.

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

* * *

Project layout
==============

Each project is its own independent entity. A new project comes with:

* `assets.json`: Used by `grabass` to install third-party assets:
  * **RequireJS**: Used to load JavaScript files. Also used to concat and minify JavaScript files for production.
  * **Almond**: Replaces RequireJS in production. Loads already defined AMD modules without loading any files.
  * **jQuery**
  * **Spine**
  * **base64**: A cross-browser base-64 en/decoder (used for authentication)
  * **Leaflet**: Map library, since most projects are gping to be using maps somehow.
  * **HTML5 shiv** For making IE8 play nice.

  Remember to keep `assets.json` file up to date with the assets you're using.

* `index.html`: A basic structure for the site is provided. Change whatever you want. `data-page="..."` attributes determine the navigation hierarchy.

* `src/scripts/site.coffee`: This is where the project comes together. Instantate your app, its projects, and their workflows, along with any other interactive bits you need.

* `src/scripts/controllers/Classifier.coffee`: This controller inherits from the base `zooniverse/controllers/Classifier` class. It is the hub for activity involving subject selection and classification creation and persistence. Put the interesting interactive bits of the project here.

* `src/scripts/tutorialSteps.coffee`: Set up your tutorial here.

* `src/scripts/controllers/Profile.coffee`: The base `zooniverse/controllers/Profile` class already provides a basic profile, but I suspects most sites will want to customize it a bit. Do that here.

* `src/styles/main.scss`: This should usually only import other files. You can store your colors in `_colors.scss`, set up a grid in `_grid.scss`, and start blocking out your layout in `_layout.scss`. Add files as you identify independent layout contexts. The `bourbon` SASS library includes some handy cross-browser CSS3 mixins.
