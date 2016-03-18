module Evented
  module Handlers
    module HTTP
      class OutboundMessage
        attr_reader :content

        def initialize(content)
          @content = content
        end

        def render
          # Start line
          outbound =  "HTTP/1.1 200 OK\r\n"

          # Headers
          outbound << "Content-Type: text/html;charset=utf-8\r\n"
          outbound << "Content-Length: 2\r\n"
          outbound << "\r\n"

          # Entity body
          outbound << "OK"
        end
      end
    end
  end
end
