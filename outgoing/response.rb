module Outgoing
  class Response
    attr_reader :request
    def initialize(request)
      @request = request
    end

    def start_line
      "HTTP/1.1 200 OK\r\n"
    end

    def headers
      {
        "Content-Type"   => "text/plain;\r\n",
        "Content-Length" => "22\r\n"
      }
    end

    def body
      "Hi! This is a message!"
    end
  end
end
