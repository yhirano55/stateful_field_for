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

```diff
class Picture < ApplicationRecord
+  stateful_field_for :hidden_at, scope: true do
+    enable  :hide, to: :hidden
+    disable :show, to: :visible, initial: true
+  end
end
```

Then you can use the bang and predicate methods:

```ruby
picture = Picture.create

picture.show!
picture.hidden?  # false
picture.visible? # true

picture.hide!
picture.hidden?  # true
picture.visible? # false
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
