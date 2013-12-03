Express-Ember-Handlebars
------------------------

This is a fork of
[interlock/connect-handlebars](https://github.com/interlock/connect-handlebars)

It doesn't actually do any compling in the node process, but rather
writes the client javascript for Ember to compile.

To make this work in an express app, do the following:

```js

var ember_handlebars = require('express-ember-handlebars');
...
app.get('/templates.js', ember_handlebars(__dirname +
'/public/templates', {
  cache: false
}));

```


