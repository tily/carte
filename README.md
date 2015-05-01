# Carte

[![npm version](https://badge.fury.io/js/carte-client.svg)](http://badge.fury.io/js/carte-client)
[![gem Version](https://badge.fury.io/rb/carte-server.svg)](http://badge.fury.io/rb/carte-server)

Something like dictionary, wiki, or information card.

## Screenshot

![](screenshot.png)

## Features

* Manage your data fragments with cards
* Create, edit and search cards quickly
* View your card with the cards around it (like paper dictionary)
* No user concept, super simple system like wiki

You can try carte on [sandbox](http://carte-sandbox.herokuapp.com/#/).
Japanese introduction is [here](http://tily.tumblr.com/post/117678137942/carte).

## Components

* [carte-server](https://rubygems.org/gems/carte-server)
* [carte-client](https://www.npmjs.com/package/carte-client)

## Deploy

```
$ git clone https://github.com/tily/carte-sandbox
$ vi config.json              # write your configuration
$ npm install                 # install carte-client and depending npm packages
$ bundle install              # install carte-server and depending gem packages
$ gulp build                  # build client-side app.js
$ bundle exec rackup          # test your carte on local
$ heroku create your-app-name # create your heroku app
$ heroku addons:add mongolab  # use mongolab as addon
$ git heroku push master      # deploy to heroku
```
