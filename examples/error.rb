enum Control
  Start
  Stop
end

items = Channel(String).new(10)
control = Channel(Control).new(10)

spawn do
  loop do
    index, value = Channel.select(items.receive_op, control.receive_op)
    case value
    when String
      puts value
    when Control
      puts "control item"
    else
      puts "else"
    end
  end
end

control.send(Control::Start)
items.send("Hello")
control.send(Control::Stop)

sleep 5
