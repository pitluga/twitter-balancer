class RequestHandler < EM::P::HeaderAndContentProtocol

  def initialize(options={})
    super
    @tweet_broadcaster = options[:tweet_broadcaster]
  end

  def receive_request(headers, content)
    response = [
      "HTTP/1.1 200 OK",
      "Content-Type: application/json",
      "\r\n"
    ]
    send_data response.join("\r\n")
  end

end
