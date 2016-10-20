require './lib/svent'
require 'pp'

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