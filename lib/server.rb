# require 'socket'
# server = TCPServer.new 8000
#
# loop do
#   session = server.accept
#   STDERR.puts request
#   request = session.posts
#   while (request = session.gets) #&& (request.chomp.length > 0)
#     puts "They said [#{request}]" # the server logs each response
#   end
#   puts "\nfinished reading"
#
#   session.puts <<-HEREDOC
# HTTP/1.1 200 OK
#
# The time is #{Time.now.strftime "%H:%M:%S(%L)"}
#   HEREDOC
#
#   session.close
# end
#

# Reference: https://www.igvita.com/2007/02/13/building-dynamic-webrick-servers-in-ruby/
require 'webrick'

class Echo < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    puts request
    response.status = 200
  end
  def do_POST(request, response)
    puts request
    response.status = 200
  end
end

server = WEBrick::HTTPServer.new(:Port => 8000)
server.mount "/", Echo
trap "INT" do server.shutdown end
server.start