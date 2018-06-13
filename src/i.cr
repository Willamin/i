module I
  VERSION = {{ `shards version __DIR__`.chomp.stringify }}

  macro script(*args)
    def script(context : I::Context)
      {% for a, i in args %}
      {{a}} = context[{{i}}]?
      {% end %}
      {{yield}}
    end
  end

  macro handle(invocation, *args)
    class Handler{{run "./md5.cr", invocation}} < I::Handler
      getter invocation = {{invocation}}
      script({{*args}}) do
        {{yield}}
      end
    end
    listener << Handler{{run "./md5.cr", invocation}}.new
  end
end

class I::Context
  @args : Array(String)
  getter invocation : String

  def initialize(@invocation, @args); end

  def [](index)
    @args[index]
  end

  def []?(index)
    @args[index]?
  end
end

abstract class I::Handler
  def invocation : String
    ""
  end

  def script(context : I::Context); end
end

class I::MissingHandler < I::Handler
  getter invocation = "*"

  def script(context : I::Context)
    STDERR.puts "nothing handles `#{context.invocation}`"
    exit 1
  end
end

class I::Listener
  @handlers : Array(I::Handler) = [] of I::Handler

  def <<(handler : I::Handler)
    @handlers << handler
  end

  def listen
    @handlers << I::MissingHandler.new
    invocation, arg_string = Tuple(String, String).from(ARGV.join(" ").split(":", 2))
    args = arg_string.split(" ").map(&.strip).reject(&.empty?)
    @handlers.each do |h|
      if h.invocation == invocation || h.invocation == "*"
        h.script(I::Context.new(invocation, args))
        break
      end
    end
  end
end
