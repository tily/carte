require 'sinatra/base'
require 'sinatra/namespace'
require 'mongoid'
require 'mongoid_auto_increment_id'
require 'will_paginate_mongoid'
require 'carte/server/models'

module Carte
  class Server < Sinatra::Base
    register Sinatra::Namespace
    include Carte::Server::Models

    configure do
      set :views, File.join(File.dirname(__FILE__), 'server/views')
    end

    helpers do
      def json_data
        request.body.rewind
        JSON.parse(request.body.read)
      end

      def search(params)
        sort_order = (params[:sort_order] && %w(asc desc random).include?(params[:sort_order])) ? params[:sort_order] : 'desc'
        sort_key = (params[:sort_key] && %w(title created_at updated_at).include?(params[:sort_key])) ? params[:sort_key] : 'updated_at'
        if sort_order == 'random'
          return Card.sample(9)
        end
        cards = Card.send(sort_order, sort_key)
        if title = params[:title]
          cards = cards.any_of({title: /#{title}/})
        end
        if content = params[:content]
          cards = cards.any_of({content: /#{content}/})
        end
        cards = cards.paginate(per_page: 9, page: params[:page])
      end
    end

    get '/cards.xml' do
      @cards = search(params)
      builder :cards
    end
    
    get '/cards.json' do
      cards = search(params)
      if cards.respond_to?(:current_page) && cards.respond_to?(:total_pages)
        current_page = cards.current_page.to_i
        total_pages = cards.total_pages
      end
      cards = cards.map {|card| {id: card.id, title: card.title, content: card.content, version: card.version}}
      {cards: cards, page: {current: current_page, total: total_pages}}.to_json
    end
    
    get '/cards/:title.json' do
      card = Card.where(title: params[:title]).first
      halt 404 if card.nil?
      {card: {id: card.id, title: card.title, content: card.content, version: card.version, lefts: card.lefts(4), rights: card.rights(4)}}.to_json
    end
    
    post '/cards.json' do
      card = Card.new(json_data)
      if card.save
        status 201
        {card: {id: card.id}}.to_json
      else
        status 400
        {card: {errors: card.errors}}.to_json
      end
    end
    
    put '/cards/:title.json' do
      card = Card.where(title: params[:title]).first
      halt 404 if card.nil?
      card.histories.create!
      if card.update_attributes(json_data.slice('new_title', 'content').compact)
        status 201
        {}.to_json
      else
        status 400
        {card: {errors: card.errors}}.to_json
      end
    end
    
    #delete '/cards/:title.json' do
    #  card = Card.where(title: params[:title]).first
    #  halt 404 if card.nil?
    #  card.destroy
    #end
    
    get '/cards/:title/history.json' do
      card = Card.where(title: params[:title]).first
      halt 404 if card.nil?
      {history: card.histories}.to_json
    end
    
    error(404) do
      {}.to_json
    end
  end
end
