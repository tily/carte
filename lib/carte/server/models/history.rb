module Carte
  class Server < Sinatra::Base
    module Models
      class History
        include Mongoid::Document
        include Mongoid::Timestamps
        field :title, type: String
        field :content, type: String
        field :version, type: Integer
        field :tags, type: Array
        belongs_to :card
      
        before_create do
          self.title = self.card.title
          self.content = self.card.content
          self.version = self.card.version
          self.tags = self.card.tags
        end
      end
    end
  end
end
