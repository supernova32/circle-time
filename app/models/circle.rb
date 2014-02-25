class Circle
  include Mongoid::Document
  field :position_x, type: Integer, default: 250
  field :position_y, type: Integer, default: 250
  field :circle_id, type: String
end
