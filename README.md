[![Build Status](https://travis-ci.org/azanar/hopper.svg)](https://travis-ci.org/azanar/hopper)
[![Dependency Status](http://img.shields.io/gemnasium/azanar/hopper.svg)](https://gemnasium.com/azanar/hopper)
[![Coverage Status](http://img.shields.io/coveralls/azanar/hopper.svg)](https://coveralls.io/r/azanar/hopper)
[![Code Climate](http://img.shields.io/codeclimate/github/azanar/hopper.svg)](https://codeclimate.com/github/azanar/hopper)
[![Gem Version](http://img.shields.io/gem/v/hopper.svg)](https://rubygems.org/gems/hopper)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://azanar.mit-license.org)
[![Badges](http://img.shields.io/:badges-7/7-ff6799.svg)](https://github.com/badges/badgerbadgerbadger)


Hopper
======
A framework for task execution written around bunny.

Usable on its own, or as part of [Hopper](https://github.com/azanar/hopper).

Examples
--------
A Publisher:

```ruby
  channel = Hopper::Channel.new

  queue = Hopper::Queue.new("hopper-stresstest")

  publisher = queue.publisher(channel)
  
  publisher.publish(m)
```

A Listener:
```ruby
 channel = Hopper::Channel.new

 queue = Hopper::Queue.new("hopper-stresstest")
  
 listener = queue.listener(channel)

 listener.listen do |m|
          
  unless valid(m)
    m.reject
    next
  end
  
  # do some stuff
  
  m.acknowledge
end
```

TODO
----

- Add support for pluggable serialization mechanisms (MsgPack, JSON, etc.)

API Documentation
-----------------

See [RubyDoc](http://rubydoc.info/github/azanar/hopper/index)

Contributors
------------

See [Contributing](CONTRIBUTING.md) for details.

License
-------

&copy;2015 Ed Carrel. Released under the MIT License.

See [License](LICENSE) for details.
