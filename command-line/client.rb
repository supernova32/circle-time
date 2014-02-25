require 'faye/websocket'
require 'eventmachine'
require 'json'

EM.run {
  ws = Faye::WebSocket::Client.new('ws://circle.patriciocano.me:3001/websocket')

  ws.on :open do |event|
    ws.send '["get_circles", {}]'
  end

  ws.on :message do |event|
    data = JSON::parse event.data
    message = data[0][0]
    parsed_data = data[0][1]
    case message
      when 'client_connected'
        system 'clear'
      when 'all_circles'
        system 'clear'
        canvas = Hash.new(' ')
        parsed_data['data'].each do |circle|
          x = Integer(circle['position_x'])/10
          y = Integer(circle['position_y'])/10
          canvas[[x, y]] = 'O'
        end
        (1..49).each do |y|
          (1..49).each do |x|
            print canvas[[x, y]]
          end
          puts
        end
      when 'new_circle_broadcast'
        ws.send '["get_circles", {}]'
      when 'new_position'
        ws.send '["get_circles", {}]'
      when 'websocket_rails.ping'
        ws.send '["websocket_rails.pong", {}]'
      when 'circle_disconnected'
        ws.send '["get_circles", {}]'
      else
        p "We got #{message}"
    end
    p
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end
}