module I
  VERSION = {{ `shards version __DIR__`.chomp.stringify }}

  def script(script_name : String)
    yield nil, nil, nil
  end
end

include I

script "say hello" do |name|
  puts "hello, #{name}"
end

# invoke with
# $ i say hello : will
# $ i say hello: will
# $ i say hello :will
