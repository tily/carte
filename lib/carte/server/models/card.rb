module Carte
  class Server < Sinatra::Base
    module Models
      class Card
        include Mongoid::Document
        include Mongoid::Timestamps
        include Mongoid::Attributes::Dynamic
      
        field :title, type: String
        field :new_title, type: String
        field :content, type: String

        index({title: 1}, {unique: true, name: "title_index"})
      
        validates :title,
          presence: {message: 'が入力されていません'},
	  on: :create
        validates :title,
          uniqueness: {message: 'は既に存在します'},
          length: {maximum: 70, message: "は 70 文字以内で入力してください"}
        validates :content,
          presence: {message: 'が入力されていません'},
          length: {maximum: 560, message: "は 560 文字以内で入力してください"}
      
        has_many :histories
      
        def version
          self.histories.size + 1
        end
      
        before_validation(on: :update) do
          self.title = self.new_title
          self.new_title = nil
        end
      
        def self.sample(size=1)
          self.in(id: (1...self.count).to_a.sample(size))
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
