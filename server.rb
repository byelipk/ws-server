require 'pry'
require 'socket'
require 'erubis'
require './connection'
require './handlers/http'
require './incoming'
require './outgoing'

module Evented
  class Server
    attr_reader :port, :host, :socket, :connections, :reactor

    def initialize(host: 'localhost', port: 3000)
      @port = port
      @host = host
      @reactor = TCPServer.new(host, port)
      @connections = Hash.new

      handle_signals!
    end

    def run
      puts "Evented::Server accepting connections on #{reactor.local_address.ip_address}:#{reactor.local_address.ip_port}"
      puts "Process ID: #{Process.pid}"

      loop do
        to_read  = connections.values.select(&:monitor_for_reading?).map(&:client)
        to_write = connections.values.select(&:monitor_for_writing?).map(&:client)

        readables, writables = IO.select(to_read + [reactor], to_write, nil, nil)

        readables.each do |socket|
          if socket == reactor
            # Accept a new connection
            io = reactor.accept

            # Add new connection to connections hash
            connections[io.fileno] = Evented::Connection.new(socket: io)
          else
            # Fetch existing connection
            connection = connections[socket.fileno]

            begin
              # Read from the socket
              connection.on_readable(
                socket.read_nonblock(1024 * 16)
              )
            rescue Errno::EAGAIN
            rescue EOFError
              connections.delete(socket.fileno)
            end
          end
        end

        writables.each do |socket|
          connection = connections[socket.fileno]
          connection.on_writable
        end
      end
    end

    private

    def handle_signals!
      Signal.trap(:INT) do
        puts "Shutting down..."
        exit(1)
      end
    end
  end
end

server = Evented::Server.new()
server.run
