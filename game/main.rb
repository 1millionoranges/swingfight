require 'ruby2d'
require './physics.rb'
require './level.rb'
require './swinger.rb'
require './rope.rb'
set title: "Spaceship thing"
set height: 800
set width: 1500

level = Level.new('args')
piece = Piece.new(pos: Vector.new(200,200), size: 30)
piece2 = Piece.new(pos: Vector.new(500,200), size: 30)
piece3 = Piece.new(pos: Vector.new(200,500), size: 30)
piece4 = Piece.new(pos: Vector.new(500,500), size: 30)
level.add_piece(piece)
level.add_piece(piece2)
level.add_piece(piece3)
level.add_piece(piece4)
level.draw_init

s = Swinger.new(pos: Vector.new(300,300), size: 10, rope_speed: 10, level: level)
s.throw_rope(Vector.new(600,600))
s.draw_init

on :mouse_down do |event|
    case event.button
    when :left
        s.throw_rope(Vector.new(event.x, event.y))
    when :right
        s.remove_all_ropes
    end
end
keys_pressed = []
on :key_down do |event|
    keys_pressed << event.key
    if event.key == "escape"
        close
    end
end

on :key_up do |event|
    keys_pressed.delete(event.key)
end

update do
    GravityObject.apply_gravity_to_everything
    level.draw_frame
    s.draw_frame
    s.tick!(keys_pressed)
end
show
