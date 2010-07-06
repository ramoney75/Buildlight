# Client for the Delcom build light server script.
#
# Written by Tom Czarniecki, ThoughtWorks

require 'socket'

class BuildLightClient

  def initialize(host, port)
    @host = host
    @port = port
  end

  def success
    send_to_server 'Success'
  end

  def failure
    send_to_server 'Failure'
  end

  def building
    send_to_server 'Building'
  end

  private

  def send_to_server(message)
    #puts "sending #{message}"
    begin
      socket = TCPSocket.new(@host, @port)
    rescue
      puts "send error: #{$!}"
    else
      socket.print message
      socket.close
    end
  end

end