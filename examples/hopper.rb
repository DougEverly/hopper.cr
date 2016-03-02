require "../src/hopper"

hopper = Hopper(String).start(capacity: 10) do |item|
  sleep 1
  puts "Got #{item}"
end

sleep 1
#hopper.start

hopper.add "Hello"
hopper.add "This"
hopper.add "is"
hopper.add "a"
hopper.stop
hopper.wait
hopper.add "test"
# sleep 5
