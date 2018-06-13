require "./i"

include I
listener = Listener.new

handle "hello", who do
  puts "hello, #{who}"
end

listener.listen
