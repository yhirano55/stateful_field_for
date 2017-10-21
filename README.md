# StatefulFieldFor

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Provide the bang and predicate methods for Active Record.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "stateful_field_for"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stateful_field_for

## Usage

```ruby
class Article < ApplicationRecord
  stateful_field_for :published_at, default: :unpublished do
    enable  :publish,   to: :published
    disable :unpublish, to: :unpublished
  end
end

article = Article.new

article.unpublished? # true
article.publish!
article.unpublished? # false
article.published?   # true
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
