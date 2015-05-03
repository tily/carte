require 'httparty'
require 'carte/server'
include Carte::Server::Models

class Carte::Server
  configure do
    Mongoid.load! 'mongoid.yml'
  end
end

class DictionaryClient
  include HTTParty
  base_uri 'http://localhost/api/'
  format :json
end

def client
  @client ||= DictionaryClient
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
        expect(response['card']['errors']).to eq({'title' => ['が入力されていません']})
      end

      it 'returns error when the content is not specified' do
        response = client.post('/cards.json', body: {title: 'card1'}.to_json) 
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'content' => ['が入力されていません']})
      end

      it 'returns error when the title is not unique' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'title' => ['は既に存在します']})
      end

      it 'returns error when the title is too long' do
        response = client.post('/cards.json', body: {title: 'w' * 71, content: 'content1'}.to_json) 
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'title' => ['は 70 文字以内で入力してください']})
      end

      it 'returns error when the content is too long' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'd' * 561}.to_json) 
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'content' => ['は 560 文字以内で入力してください']})
      end

      it 'returns error when the tags is too many' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1', tags: %w(tag1 tag2 tag3 tag4)}.to_json)
        expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'tags' => ['are too many (maximum is 3 tags)']})
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
        expect(response['card']['errors']).to eq({'title' => ['は既に存在します']})
      end

      it 'returns error when the title is too long' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
        response = client.put("/cards/card1.json", body: {new_title: 'w' * 71}.to_json) 
	expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'title' => ['は 70 文字以内で入力してください']})
      end

      it 'returns error when the content is too long' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json) 
        response = client.put("/cards/card1.json", body: {content: 'd' * 561}.to_json) 
	expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'content' => ['は 560 文字以内で入力してください']})
      end

      it 'returns error when the tags is too many' do
        response = client.post('/cards.json', body: {title: 'card1', content: 'content1'}.to_json)
        response = client.put("/cards/card1.json", body: {tags: %w(tag1 tag2 tag3 tag4)}.to_json)
	expect(response.code).to eq(400)
        expect(response['card']['errors']).to eq({'tags' => ['are too many (maximum is 3 tags)']})
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
end
