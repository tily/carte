module Carte
  class Server < Sinatra::Base
    module Models
      class Card
        include Mongoid::Document
        include Mongoid::Timestamps
        include Mongoid::Attributes::Dynamic
        include Mongoid::Document::Taggable
        include Mongoid::Geospatial
      
        field :title, type: String
        field :new_title, type: String
        field :content, type: String
        field :random_point, type: Point, spatial: true

        index({title: 1}, {unique: true, name: "title_index"})
      
        validates :title,
          presence: true,
	  on: :create
        validates :title,
          uniqueness: true,
          length: {maximum: (ENV['CARTE_TITLE_MAX_LENGTH'] || 70).to_i}
        validates :content,
          presence: true,
          length: {maximum: (ENV['CARTE_DESCRIPTION_MAX_LENGTH'] || 560).to_i}
        validates :tags,
          length: {maximum: (ENV['CARTE_TAGS_MAX_SIZE'] || 3).to_i, message: 'are too many (maximum is 3 tags)'},
          array: {length: {maximum: (ENV['CARTE_TAG_MAX_LENGTH'] || 10).to_i}}
      
        has_many :histories
      
        def version
          self.histories.size + 1
        end
      
        before_validation(on: :update) do
          if self.new_title
            self.title = self.new_title
            self.new_title = nil
          end
        end

        before_create do
          self.random_point = [Random.rand, 0]
        end
      
        def self.random
          self.near(random_point: [Random.rand, 0])
        end
      
        def lefts(size=1)
          ids = []
          count = self.class.all.count
          1.upto(size) do |i|
            ids << (self.id - i > 0 ? self.id - i : count + (self.id - i))
          end
          self.class.in(id: ids)
        end
      
        def rights(size=1)
          ids = []
          count = self.class.all.count
          1.upto(size) do |i|
            ids << (self.id + i <= count ? self.id + i : self.id + i - count)
          end
          self.class.in(id: ids)
        end
      end
    end
  end
end
