require "./hopper/*"

enum Control
  Start
  Stop
end

class Hopper(T)
  def initialize(capacity = 10, @timeout = 2, @always = false, @exact = true, &@block : T -> Void)
    @running = false
    @chan = Channel(T | Control).new(capacity + 2)
    @done = Channel(Control).new(1)
    run
  end

  def self.start(capacity = 10, timeout = 2, always = false, exact = true, &block : T -> Void)
    new(capacity, timeout, always, exact, &block)
  end

  def start
    @chan.send(Control::Start)
  end

  def run
    return unless @block
    spawn do
      @running = true
      puts "Starting..."
      loop do
        value = @chan.receive
        case value
        when T
          @block.call(value)
        when Control
          if value == Control::Stop
            @chan.close
          end
        else
        end
        if @chan.empty? && @chan.closed?
          @done.send(Control::Stop)
          break
        end
      end
    end
  end

  def add(item : T)
    @chan.send(item) unless @chan.closed?
  end

  def stop
    @running = false
    @chan.close
  end

  def wait
    v = @done.receive
  end

  def shutdown
    stop
    wait
  end
end
