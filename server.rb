require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8000

CACHE = {}

def in_fib(n)
  result = nil
  unless n.is_a?(Integer) and n > 0
    raise "I only work with Integers 1 and above... sorry"
  end

  if [1, 2].include? n
    result = 1
  end

  if CACHE[n]
    return CACHE[n]
  end

  if n > 2
    result = in_fib(n - 2) + in_fib(n - 1)
    CACHE[n] = result
  end

  return result
end

class FibServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    if request.query["sequence_num"]
      sequence_num = request.query["sequence_num"].to_i
      response.status = 200
      response.content_type = "text/plain"
      result = nil

      if request.path == "/fib"
        result = in_fib(sequence_num)
      else
        result = "No such method"
      end

      response.body = "#{result}\n"
    else
      response.status = 404
      response.body = "You did not provide the correct parameters"
    end
  end
end

server.mount "/", FibServlet

# Catches "Control+C"
trap("INT") do
  # print out a pretty message!
  puts "Looks like it is time to shutdown!"
  server.shutdown
end

server.start
