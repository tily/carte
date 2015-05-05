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

| Package Name | Description |
|--------------|-------------|
| [carte-server](https://rubygems.org/gems/carte-server)     | provides JSON API (document is [here](https://github.com/tily/carte/wiki/API))  |
* [carte-client](https://www.npmjs.com/package/carte-client) | builds client side javascript         |
 
## Deploy

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/tily/carte-sandbox)

Deploy your carte with the button above. After deployment, you may want to customize your carte.

```
## change title and description
$ vi config.json
## replace brand icon
$ cp ~/Desktop/icon.png public/images/icon.png 
```
