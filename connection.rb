module Evented
  class Connection
    attr_reader :client, :response, :handler

    def initialize(socket: nil, handler: Handlers::HTTP::Base.new)
      @client   = socket
      @handler  = handler
      @response = ""
    end

    def on_readable(request)
      @response = handler.handle(request, client)
    end

    def on_writable
      @response.slice!(0, bytes)
    end

    def bytes
      client.write_nonblock(response)
    end

    def monitor_for_reading?
      true
    end

    def monitor_for_writing?
      !(response.empty?)
    end
  end
end
