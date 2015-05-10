require 'httparty'
require 'carte/server'
include Carte::Server::Models

class Carte::Server
  configure do
    Mongoid.load! 'mongoid.yml'
  end
end

class CarteClient
  include HTTParty
  base_uri ENV['CARTE_API_ENDPOINT'] || 'http://localhost:9393/api/'
  format :json
end

def client
  @client ||= CarteClient
end

describe 'API' do
  before do
    [Card, History].each do |model|
      model.delete_all
    end
  end

  context 'POST /cards.json' do
    it 'creates a card' do
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
      expect(response.code).to eq(201)
      expect(response['card']['id']).to be_numeric
      response = client.get('/cards.json')
      expect(response['cards'][0]['title']).to eq('card1')
      expect(response['cards'][0]['content']).to eq('content1')
      expect(response['cards'][0]['version']).to eq(1)
    end

    context 'error' do
      it 'returns error when the title is not specified' do
        response = client.post('/cards.json', body: {content: 'content1'}.to_json) 
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'title' => ["can't be blank"]})
      end

      it 'returns error when the content is not specified' do
        response = client.post('/cards.json', body: {title: 'card1'}.to_json) 
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'content' => ["can't be blank"]})
      end

      it 'returns error when the title is not unique' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'title' => ['is already taken']})
      end

      it 'returns error when the title is too long' do
        response = client.post('/cards.json', body: {title: 'w' * 71, content: 'content1'}.to_json) 
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'title' => ['is too long (maximum is 70 characters)']})
      end

      it 'returns error when the content is too long' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'd' * 561}.to_json) 
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'content' => ['is too long (maximum is 560 characters)']})
      end

      it 'returns error when the tags is too many' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1', tags: %w(tag1 tag2 tag3 tag4)}.to_json)
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'tags' => ['are too many (maximum is 3 tags)']})
      end

      it 'returns error when one of the tags is too long' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1', tags: ['a' * 11]}.to_json)
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'tags' => ['is too long (maximum is 10 characters)']})
      end
    end
  end

  context 'GET /cards.json' do
    it 'returns cards' do
      pending
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
      response = client.get('/cards.json')
      expect(response.code).to eq(200)
    end

    context 'with parameters' do
      pending
    end
  end

  context 'GET /cards/:title.json' do
    it 'returns the card' do
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
      response = client.get("/cards/card1.json")
      expect(response.code).to eq(200)
      expect(response['card']['title']).to eq('card1')
      expect(response['card']['content']).to eq('content1')
      expect(response['card']['version']).to be(1)
    end

    context 'error' do
      it 'returns error when the card is not found' do
        response = client.get("/cards/notexists.json")
	expect(response.code).to eq(404)
	expect(response.parsed_response).to eq({})
      end
    end
  end

  context 'PUT /cards/:title.json' do
    it 'updates the card' do
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
      response = client.put("/cards/card1.json", body: {new_title: 'card1updated', content: 'content1updated'}.to_json)
      expect(response.code).to eq(201)
      expect(response.parsed_response).to eq({})
      response = client.get("/cards/card1updated.json")
      expect(response['card']['title']).to eq('card1updated')
      expect(response['card']['content']).to eq('content1updated')
      expect(response['card']['version']).to eq(2)
    end

    context 'error' do
      it 'returns error when the card is not found' do
        response = client.put("/cards/notexists.json", body: {new_title: 'card1updated', content: 'content1updated'}.to_json)
	expect(response.code).to eq(404)
	expect(response.parsed_response).to eq({})
      end

      it 'returns error when the title is not unique' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
        response = client.post('/cards.json', body: {title: 'card2', content: 'content2'}.to_json) 
        response = client.put("/cards/card2.json", body: {new_title: 'card1', content: 'content1'}.to_json)
	expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'title' => ['is already taken']})
      end

      it 'returns error when the title is too long' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
        response = client.put("/cards/card1.json", body: {new_title: 'w' * 71}.to_json) 
	expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'title' => ['is too long (maximum is 70 characters)']})
      end

      it 'returns error when the content is too long' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
        response = client.put("/cards/card1.json", body: {content: 'd' * 561}.to_json) 
	expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'content' => ['is too long (maximum is 560 characters)']})
      end

      it 'returns error when the tags is too many' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json)
        response = client.put("/cards/card1.json", body: {tags: %w(tag1 tag2 tag3 tag4)}.to_json)
	expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'tags' => ['are too many (maximum is 3 tags)']})
      end

      it 'returns error when one of the tags is too long' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json)
        response = client.put("/cards/card1.json", body: {tags: ['a' * 11]}.to_json)
	expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'tags' => ['is too long (maximum is 10 characters)']})
      end
    end
  end

  context 'GET /cards/:title/history.json' do
    it 'returns no history when there is no history' do
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
      response = client.get("/cards/card1/history.json")
      expect(response.code).to eq(200)
      expect(response['history']).to eq([])
    end

    it 'returns history when there is history' do
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
      response = client.put("/cards/card1.json", body: {new_title: 'card1updated1', content: 'content1updated1'}.to_json)
      response = client.put("/cards/card1updated1.json", body: {new_title: 'card1updated2', content: 'content1updated2'}.to_json)
      response = client.put("/cards/card1updated2.json", body: {new_title: 'card1updated3', content: 'content1updated3'}.to_json)
      response = client.get("/cards/card1updated3/history.json")
      expect(response.code).to eq(200)
      expect(response['history'].size).to eq(3)
    end

    context 'error' do
      it 'returns error when the card is not found' do
        response = client.get("/cards/notexists/history.json")
	expect(response.code).to eq(404)
	expect(response.parsed_response).to eq({})
      end
    end
  end

  context 'Tags' do
    it 'can create and get a card with tags' do
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1', tags: %w(tag1 tag2 tag3)}.to_json)
      expect(response.code).to eq(201)
      response = client.get("/cards/card1.json")
      expect(response['card']['tags']).to eq %w(tag1 tag2 tag3)
    end

    it 'can update card with tags' do
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1', tags: %w(tag1 tag2 tag3)}.to_json)
      response = client.put("/cards/card1.json", body: {tags: %w(tag4 tag5 tag6)}.to_json)
      expect(response.code).to eq(201)
      response = client.get("/cards/card1.json")
      expect(response['card']['tags']).to eq %w(tag4 tag5 tag6)
    end

    it 'can list cards with tags' do
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1', tags: %w(tag1 tag2 tag3)}.to_json)
      response = client.get("/cards.json", query: {name: '^cards1$'})
      expect(response['cards'].first['tags']).to eq %w(tag1 tag2 tag3)
    end

    it 'can search cards by tags' do
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1', tags: %w(tag1 tag2 tag3)}.to_json)
      response = client.get("/cards.json", query: {tags: 'tag1,tag2,tag3'})
      expect(response['cards'].size).to eq(1)
      expect(response['cards'].first['tags']).to eq %w(tag1 tag2 tag3)
    end

    it 'can get tags' do
      response = client.post('/cards.json', body: {title: 'card1', content: 'content1', tags: %w(tag1 tag2 tag3)}.to_json)
      response = client.post('/cards.json', body: {title: 'card2', content: 'content2', tags: %w(tag4 tag5 tag6)}.to_json)
      response = client.get("/tags.json")
      expect(response['tags'].size).to eq(6)
    end
  end

  context 'For document' do
    it 'POST /cards.json' do
     cards = [
       ['The Fool', 'The Fool or The Jester is one of the 78 cards in a Tarot deck; one of the 22 Trump cards that make up the Major Arcana. The Fool is unnumbered; sometimes represented as 0 (the first) or XXI (the second to last) or XXII (the last) Major Arcana in decks. It is used in divination as well as in game playing.'],
       ['The Magician', 'The Magician, The Magus, or The Juggler (I) is the first trump or Major Arcana card in most traditional Tarot decks. It is used in game playing as well as in divination. In divination it is considered by some to succeed The Fool card, often numbered 0.'],
       ['The High Priestess', 'The High Priestess (II) is the second trump or Major Arcana card in most traditional Tarot decks. This card is used in game playing as well as in divination. In the first Tarot pack with inscriptions, the 18th-century woodcut Marseilles Tarot, this figure is crowned with the Papal tiara and labelled La Papesse, the Popess, a possible reference to the legend of Pope Joan.'],
       ['The Empress', 'The Empress (III) is the third trump or Major Arcana card in traditional Tarot decks. It is used in Tarot card games as well as divination.'],
       ['The Emperor', 'The Emperor (IV) is the fourth trump or Major Arcana card in traditional Tarot decks. It is used in game playing as well as in divination.'],
       ['The Hierophant', 'The Hierophant (V), in some decks named The Pope, is the fifth trump or Major Arcana card in most traditional Tarot decks. It is used in game playing as well as in divination.'],
       ['The Lovers', 'The Lovers (VI) is the sixth trump or Major Arcana card in most traditional Tarot decks. It is used in game playing as well as in divination.'],
       ['The Chariot', 'The Chariot (VII) is the seventh trump or Major Arcana card in most traditional Tarot decks. It is used in game playing as well as in divination.'],
       ['Justice', 'Justice is a Major Arcana Tarot card, numbered either VIII or XI, depending on the deck. This card is used in game playing as well as in divination.'],
       ['The Hermit', 'The Hermit (IX) is the ninth trump or Major Arcana card in most traditional Tarot decks. It is used in game playing as well as in divination.'],
       ['Wheel of Fortune', 'Wheel of Fortune (X) is the tenth trump or Major Arcana card in most Tarot decks. It is used in game playing as well as in divination.'],
       ['Strength', 'Strength is a Major Arcana Tarot card, and is numbered either XI or VIII, depending on the deck. Historically it was called Fortitude, and in the Thoth Tarot deck it is called Lust. This card is used in game playing as well as in divination.'],
       ['The Hanged Man', 'The Hanged Man (XII) is the twelfth trump or Major Arcana card in most traditional Tarot decks. It is used in game playing as well as in divination. It depicts a pittura infamante, a shameful image of a traitor being punished in a manner common at the time for traitors in Italy.'],
       ['Death', 'Death (XIII) is the thirteenth trump or Major Arcana card in most traditional Tarot decks. It is used in Tarot, tarock and tarocchi games as well as in divination.'],
       ['Temperance', 'Temperance (XIV) is the fourteenth trump or Major Arcana card in most traditional Tarot decks. It is used in game playing as well as in divination.'],
       ['The Devil', 'The Devil (XV) is the fifteenth trump or Major Arcana card in most traditional Tarot decks. It is used in game playing as well as in divination.'],
       ['The Tower', 'The Tower (XVI) (most common modern name) is the 16th trump or Major Arcana card in most Italian-suited Tarot decks. It is used in game playing as well as in divination.'],
       ['The Star', 'The Star (XVII) is the seventeenth trump or Major Arcana card in most traditional Tarot decks. It is used in game playing as well as in divination.'],
       ['The Moon', 'The Moon (XVIII) is the eighteenth trump or Major Arcana card in most traditional Tarot decks. It is used in game playing as well as in divination.'],
       ['The Sun', 'The Sun (XIX) is a trump card in the tarot deck. Tarot trumps are often called Major Arcana by tarot card readers.'],
       ['Judgement', 'Judgement (XX), or in some decks spelled Judgment, is a Tarot card, part of the Major Arcana suit usually comprising 22 cards.'],
       ['The World', 'The World (XXI) is a trump or Major Arcana card in the tarot deck. It is usually the final card of the Major Arcana or tarot trump sequence. In the tarot family of card games, this card is usually worth five points.'],
     ]
     cards.each do |card|
       body = JSON.pretty_generate(title: card.first, content: card.last, tags: ['tarot', 'arcana'])
       puts body
       response = client.post('/cards.json', body: body)
       puts JSON.pretty_generate response
     end 

     people = [
       ['The Fool', nil],
       ['The Magician', 'I'],
       ['The High Priestess', 'II'],
       ['The Empress', 'III'],
       ['The Emperor', 'IV'],
       ['The Hierophant', 'V'],
       ['The Lovers', 'VI'],
       ['The Chariot', 'VII'],
       ['The Hermit', 'IX'],
       ['The Hanged Man', 'XII']
     ]
     people.each do |person|
       body = JSON.pretty_generate(new_title: "#{person.first} (#{person.last})", tags: %w(tarot arcana people))
       puts body
       response = client.put("/cards/#{URI.escape person.first}.json", body: body)
       puts JSON.pretty_generate response
     end

     response = client.get('/cards.json', query: {sort:'title', order: 'asc', tags: 'people', title: '^The (C|E)'})
     puts JSON.pretty_generate response

     response = client.get("/cards/#{URI.escape 'The Hierophant (V)'}.json", query: {context: 'title'})
     puts JSON.pretty_generate response

     response = client.get("/cards/#{URI.escape 'The Hierophant (V)'}/history.json")
     puts JSON.pretty_generate response

     response = client.get("/tags.json")
     puts JSON.pretty_generate response
    end 
  end
end
