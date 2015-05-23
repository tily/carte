Card = require './card'

module.exports = class CardHistory extends Card
  modelName: 'CardHistory'
  idAttribute: 'version'
