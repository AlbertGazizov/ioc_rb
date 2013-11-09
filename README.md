# IocRb

IocRb is a Inversion of Control container for Ruby.
It takes advantage of the dynamic nature of Ruby to provide a rich and flexible approach to injecting dependencies.
It's inspired by SpringIoc and tries to give you the same features.

## Usage
Lets say you have a Logger which has the Appender dependency

```ruby
class Logger
  attr_accessor :appender

  def info(message)
    # do some work with appender
  end
end

class Appender
end
```
To use Logger you need to inject the instance of Appender class, for example
using setter injection:
logger = Logger.new
logger.appender = Appender.new
logger.info('some message')

IocRb removes manual injection step and injects dependencies by itself.
To use IocRb you need to instantiate IocRb::Container and pass dependencies to it:
```ruby
container = IocRb::Container.new do |c|
  c.bean(:appender, class: Appender)
  c.bean(:logger, class: Logger) do
    attr :appender, ref: :appender
  end
end
```
Now you can get the Logger instance from IocRb with already set dependencies:
```ruby
logger = container[:logger]
logger.info('some message')
```

To simplify injection IocRb provides and analog of Java annotations, it allows you
specify which dependency to inject inside of class:
```ruby
class Logger
  inject :appender

  def info(message)
    # do some work with appender
  end
end

class Appender
end
```

With `inject` keyword you won't need to specify bean dependencies in beans definitions:
```ruby
container = IocRb::Container.new do |c|
  c.bean(:appender, class: Appender)
  c.bean(:logger, class: Logger)
end
```

Now you can use container as usual:
```ruby
logger = container[:logger]
logger.info('some message')
```

## Installation

Add this line to your application's Gemfile:

    gem 'ioc_rb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ioc_rb

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# TODO
1 fix passing multiple names to inject
2 implement scopes
