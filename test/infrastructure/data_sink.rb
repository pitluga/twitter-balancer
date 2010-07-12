class DataSink
  attr_reader :sent_data, :signature

  def initialize
    @sent_data = []
    @signature = rand
  end

  def send_data(data)
    sent_data << data
  end

end
