class CirclesController < WebsocketRails::BaseController

  def initialize_session
    # perform application setup here
    controller_store[:circle_count] = 0
  end

  def register_circle
    controller_store[:circle_count] += 1
    #Circle.create [position_x: 250, position_y: 250]
    #circle = Circle.last
    circle = Circle.create
    circle.circle_id = circle.id.to_s
    circle.save
    connection_store[:circle_id] = circle.id.to_s
    trigger_success message: circle.id.to_s
    broadcast_message :new_circle_broadcast, circle
  end

  def register_connection
    connection_store[:circle_id] = 0
    send_message :connection_accepted, 'Connection established!'
  end

  def retrieve_id
    id = connection_store[:circle_id]
    trigger_success message: id
  end

  def position_circle
    circle = Circle.find(message[:id])
    circle.position_x = message[:position_x]
    circle.position_y = message[:position_y]
    circle.save
    broadcast_message :new_position, circle
  end

  def all_circles
    send_message :all_circles, Circle.all
  end

  def delete_circle
    unless connection_store[:circle_id] == 0
      controller_store[:circle_count] -= 1
      #circle = Circle.find(connection_store[:circle_id])
      #id = circle.id
      #circle.delete
      Circle.find(connection_store[:circle_id]).delete
      broadcast_message :circle_disconnected, connection_store[:circle_id]
    end
  end


end