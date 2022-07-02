require 'benchmark'

class AuthorBlueprintSerializer < Blueprinter::Base
  identifier :id

  field :name
end

class BookBlueprintSerializer < Blueprinter::Base
  identifier :id

  fields :title, :genre, :description

  association :author, blueprint: AuthorBlueprintSerializer

  field :title_with_genre do |resource|
    "#{resource.title}: #{resource.genre}"
  end
end

class AuthorAlbaSerializer
  include Alba::Resource
  attributes :id, :name
end

class BookAlbaSerializer
  include Alba::Resource

  root_key :book

  attributes :id, :title, :genre, :description

  one :author, resource: AuthorAlbaSerializer

  attribute :title_with_genre do |resource|
    "#{resource.title}: #{resource.genre}"
  end
end

class AuthorFastJsonApiSerializer
  include JSONAPI::Serializer
  set_type :book
  set_id :id

  attributes :name
end

class BookFastJsonApiSerializer
  include JSONAPI::Serializer

  set_type :book
  set_id :id

  attributes :title, :genre, :description
  belongs_to :author, serializer: AuthorFastJsonApiSerializer
end

task benchmark: :environment do
  books = Book.all.to_a

  Benchmark.bm do |x|
    x.report("blueprinter") { BookBlueprintSerializer.render(books) }
    x.report("alba") { BookAlbaSerializer.new(books).serialize }
    x.report("fast JSON API") { BookFastJsonApiSerializer.new(books).serializable_hash.to_json }
  end
end
