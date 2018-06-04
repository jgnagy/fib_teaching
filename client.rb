require 'net/http'

# Where is our server?
uri = URI('http://localhost:8000')
# Create an actual HTTP client
client = Net::HTTP.new(uri.host, uri.port)

# What number do we want?
number = ARGV[0]

# Go get our answer...
start = Time.now
result = client.get("/fib?sequence_num=#{number}")
finish = Time.now

# print out the result
puts "Got: #{result.body}"
puts "Took: #{finish - start} seconds"
