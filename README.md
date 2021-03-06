# Svent
[![Gem Version](https://badge.fury.io/rb/svent.svg)](http://badge.fury.io/rb/svent)
[![Build Status](https://travis-ci.org/molingyu/svent.svg?branch=master)](https://travis-ci.org/molingyu/svent)
[![Code Climate](https://codeclimate.com/github/molingyu/svent/badges/gpa.svg)](https://codeclimate.com/github/molingyu/svent)

Svent is an async event framework implemented with Fiber.Used for game or GUI event handling.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'svent'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install svent

## Usage

```ruby
require 'svent'

Svent.run do |manger|
  manger.on(:click) do |em, info|
    puts "click!(pos:{x:#{info.x} y:#{info.y}})"
    puts 'wait 5 sec'
    Svent.stop
    em.wait(5)
    puts 'after 5 sec'
    puts 'delete!'
    em.delete # delete this callback
    puts 'delete!'#not output
  end
  manger.trigger(:click, {x:233, y:666})
end

#-----------output---------------
# click!(pos:{x:233 y:666})
# wait 5 sec
# after 5 sec
# delete!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/molingyu/svent. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

