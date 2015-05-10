# Carte

* client: [![npm version](https://badge.fury.io/js/carte-client.svg)](http://badge.fury.io/js/carte-client) [![npm dependencies](https://david-dm.org/tily/carte.svg)](https://david-dm.org/tily/carte)
* server: [![gem version](https://badge.fury.io/rb/carte-server.svg)](http://badge.fury.io/rb/carte-server) [![Code Climate](https://codeclimate.com/github/tily/carte/badges/gpa.svg)](https://codeclimate.com/github/tily/carte) [![Build Status](https://travis-ci.org/tily/carte.svg?branch=master)](https://travis-ci.org/tily/carte)

Something like dictionary, wiki, or information card.

## Screenshot

![](screenshot.png)

You can try carte on [sandbox](http://carte-sandbox.herokuapp.com/#/). There is also [a French-Japanese dictionary version](https://carte-francais.herokuapp.com/#/).

## Features

* Manage your data fragments with cards
* Create, edit and search cards quickly
* View your card with the cards around it (like paper dictionary)
* No user concept, super simple system like wiki

Japanese introduction is [here](http://tily.tumblr.com/post/117678137942/carte).

## Components

| Package Name | Description |
|--------------|-------------|
| [carte-server](https://rubygems.org/gems/carte-server)     | provides JSON API (document is [here](https://github.com/tily/carte/wiki/API))  |
| [carte-client](https://www.npmjs.com/package/carte-client) | builds client side javascript         |
 
## Deploy

**Heroku**

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/tily/carte-sandbox)

**Docker**

```bash
$ docker build -t carte .
$ docker run --name mongo -d mongo
$ docker run --name carte --link mongo:mongo -p 80:80 -d carte
```

After deployment, you may want to [customize your carte](https://github.com/tily/carte/wiki/Configuration).
