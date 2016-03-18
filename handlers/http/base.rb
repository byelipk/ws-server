module Evented
  module Handlers
    module HTTP
      class Base
        def handle(inbound, client)
          # Parse inbound message
          request  = Incoming::Request.new(inbound)

          # Build up an outgoing response
          response = Outgoing::Response.new(request)
          outbound = String.new

          # Start line
          outbound << response.start_line

          # Set response headers
          response.headers.each { |k,v| outbound << "#{k}: #{v}" }

          # CRLF before response body
          outbound << "\r\n"

          # Build entity body
          outbound << response.body
        end
      end
    end
  end
end
