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

Deploy your carte to click [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/tily/carte-sandbox).
After deployment, you can customize your carte as below: 

```
## change title
$ vi config.json
## replace icon
$ cp ~/Desktop/icon.png public/images/icon.png 
```
