class StubTwitterStream

  def each_item(&block)
    @item_handler = block
  end

  def push_message(msg)
    @item_handler.call msg
  end

  def on_error
  end

  def on_max_reconnects
  end
end
