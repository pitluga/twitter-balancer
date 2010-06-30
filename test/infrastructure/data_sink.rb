class DataSink
  attr_reader :sent_data

  def initialize
    @sent_data = []
  end

  def send_data(data)
    sent_data << data
  end

end
