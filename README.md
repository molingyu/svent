# Svent

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

manger = Svent::EventManger.new

manger.on(:click) do |em, info|
    if info
        puts 'delete!'
        em.delete # delete this callback
    end
    puts 'click!'
    em.wait(10)
    puts 'before 10 sec'
    em.wait(5)
    em.trigger(:click, true) 
end

manger.trigger(:click)

Svent.run(manger)

#------------out-------------
click!
# wait 10 sec
before 10 sec
# wait 5 sec
delete!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/svent. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

