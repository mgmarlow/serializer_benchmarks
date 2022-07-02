# README

## results

Serializing 1000 models with 1 `belongs_to` association:

```
$ bin/rake benchmark
               user       system     total     real
blueprinter    0.300604   0.016432   0.317036 (0.317469)
alba           0.013638   0.000152   0.013790 (0.013795)
fast JSON API  0.055477   0.000699   0.056176 (0.056178)
```

## prototype walkthrough

Setup

```sh
rails new serializer_benchmark --api

# Faker for seeds
bundle add faker

# Serializer gems
bundle add alba
bundle add blueprinter
bundle add jsonapi-serializer

# Simple db setup, SQLite
rails g model Author name:string
rails g scaffold Book title:string genre:string description:text author:references
bin/rails db:migrate
```

Seed some data

```rb
# db/seeds.rb
require 'faker'

1000.times do
  author = Author.find_or_create_by(name: Faker::Book.author)
  Book.create({
    title: Faker::Book.title,
    author: author,
    genre: Faker::book.genre,
    description: Faker::Lorem.paragraph
  })
end
```

```
bin/rails db:seed
```

Finally, the benchmark code: [lib/tasks/benchmark.rake](./lib/tasks/benchmark.rake).
