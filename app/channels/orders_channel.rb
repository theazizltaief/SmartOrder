# app/channels/orders_channel.rb
class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "orders_stream"
    Rails.logger.info "🔔 [OrdersChannel] Client abonné au stream 'orders_stream'"
  end

  def unsubscribed
    Rails.logger.info "🔕 [OrdersChannel] Client désabonné du stream 'orders_stream'"
    # Any cleanup needed when channel is unsubscribed
  end
end
