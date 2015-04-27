class History
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :description, type: String
  field :version, type: Integer
  belongs_to :word

  before_create do
    self.name = self.word.name
    self.description = self.word.description
    self.version = self.word.version
  end
end
