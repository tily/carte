require 'sinatra/base'
require 'sinatra/namespace'
require 'mongoid'
require 'mongoid_auto_increment_id'
require 'will_paginate_mongoid'
require 'mongoid-simple-tags'
require 'mongoid/geospatial'
require 'redcarpet'
require 'carte/server/validators'
require 'carte/server/models'

module Carte
  class Server < Sinatra::Base
    use Rack::Deflater
    register Sinatra::Namespace
    include Carte::Server::Models

    configure do
      set :protection, :except => :path_traversal
      set :views, File.join(File.dirname(__FILE__), 'server/views')
      set :public_folder, 'public'
      set :default, JSON.parse(File.read(File.join(File.dirname(__FILE__), 'shared/default.json')))
      set :carte, {}
    end

    helpers do
      def config
        @config ||= settings.default.update(settings.carte)
      end

      def json_data
        request.body.rewind
        JSON.parse(request.body.read)
      end

      def search(params)
        order = (params[:order] && %w(asc desc random).include?(params[:order])) ? params[:order] : 'desc'
        sort = (params[:sort] && %w(title created_at updated_at).include?(params[:sort])) ? params[:sort] : 'updated_at'
        if order == 'random'
          cards = Card.random
        else
          cards = Card.send(order, sort)
        end
        conditions = []
        if title = params[:title]
          conditions << {title: /#{title}/i}
        end
        if content = params[:content]
          conditions << {content: /#{content}/i}
        end
        if conditions.size > 0
          cards = cards.any_of(conditions)
        end
        if params[:tags]
          tags = params[:tags].split(',')
          cards = cards.tagged_with_all(tags)
        end
        cards = cards.paginate(per_page: 9, page: params[:page])
      end

      def markdown2html(markdown)
        renderer = Redcarpet::Render::HTML.new(filter_html:true)
        Redcarpet::Markdown.new(renderer, autolink: true).render(markdown)
      end
    end

    get '/cards.xml' do
      @cards = search(params)
      builder :cards
    end
    
    get '/cards.json' do
      cards = search(params)
      {
        cards: cards.map {|card| card.as_json(only: %w(title content tags)).update(version: card.version) },
        pagination: {current_page: cards.current_page, total_pages: cards.total_pages, total_entries: cards.total_entries}
      }.to_json
    end
    
    get '/cards/:title.json' do
      context = (params[:context] && %w(title created_at updated_at).include?(params[:context])) ? params[:context] : 'created_at'
      card = Card.where(title: params[:title]).first
      halt 404 if card.nil?
      {
        card: card.as_json(only: %w(title content version tags)).update(
          version: card.version,
          lefts: card.lefts(4, context).as_json(only: %w(title content version tags)),
          rights: card.rights(4, context).as_json(only: %w(title content version tags))
        )
      }.to_json
    end

    post '/cards.json' do
      card = Card.new(json_data.slice('title', 'content', 'tags'))
      if card.save
        status 201
        {}.to_json
      else
        status 400
        {card: {errors: card.errors}}.to_json
      end
    end
 
    put '/cards/:title.json' do
      card = Card.where(title: params[:title]).first
      halt 404 if card.nil?
      card.histories.create!
      if card.update_attributes(json_data.slice('new_title', 'content', 'tags').compact)
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
      {history: card.histories.as_json(only: %w(title content version tags))}.to_json
    end

    get '/tags.json' do
      {tags: Card.all_tags}.to_json
    end

    error(404) do
      {}.to_json
    end
  end
end
